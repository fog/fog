module Fog
  module Compute
    class Vsphere

      module Shared
        private
        def vm_clone_check_options(options)
          default_options = {
            'force'        => false,
            'linked_clone' => false,
          }
          options = default_options.merge(options)
          # Backwards compatibility settings
          if ( options.has_key? 'path' )
            options['template_path'] ||= options['path']
          end
          required_options = %w{ template_path name }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.has_key? param
          end
          # The tap removes the leading empty string
          path_elements = options['template_path'].split('/').tap { |o| o.shift }
          first_folder = path_elements.shift
          if first_folder != 'Datacenters' then
            raise ArgumentError, "vm_clone path option must start with /Datacenters.  Got: #{options['path']}"
          end
          dc_name = path_elements.shift
          if not self.datacenters.include? dc_name then
            raise ArgumentError, "Datacenter #{dc_name} does not exist, only datacenters #{self.datacenters.join(",")} are accessible."
          end
          
          options
        end

        def find_folder_obj(path, has_file = true)
          # Find the folder first, as this is more efficient than
          # searching ALL VM's looking for the template.
          # Tap gets rid of the leading empty string and "Datacenters" element
          # and returns the array.
          path_elements = path.split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          path_dc = path_elements.shift
          # If the first path element contains "vm" this denotes the vmFolder
          # and needs to be shifted out
          path_elements.shift if path_elements[0] == 'vm'
          # Pop the filename off if the path has one (see has_file)s
          path_elements.pop if has_file
          # Make sure @datacenters is populated.  We need the instances from the Hash keys.
          self.datacenters
          # Get the datacenter managed object from the hash
          dc = @datacenters[path_dc]
          # Get the VM Folder (Group) efficiently
          vm_folder = dc.vmFolder
          # Walk the tree resetting the folder pointer as we go
          folder = path_elements.inject(vm_folder) do |current_folder, sub_folder_name|
            # JJM VIM::Folder#find appears to be quite efficient as it uses the
            # searchIndex It certainly appears to be faster than
            # VIM::Folder#inventory since that returns _all_ managed objects of
            # a certain type _and_ their properties.
            sub_folder = current_folder.find(sub_folder_name, RbVmomi::VIM::Folder)
            raise ArgumentError, "Could not descend into #{sub_folder_name}.  Please check your path: #{path}" unless sub_folder
            sub_folder
          end
        end
        
        def find_resource_pool_obj(datacenter, cluster_name, pool_name)
          # Pull the Resource Object
          cluster = datacenter.find_compute_resource(cluster_name)
          resource_pool = cluster.resourcePool.find(pool_name)
        end
        
        def find_datastore_obj(datacenter, datastore_name)
          # Pull datastore Object by name
          datastore = datacenter.datastoreFolder.find(datastore_name)
        end
        
        def find_network_obj(datacenter, network_label)
          # Pull network label object by name
          network_obj = datacenter.networkFolder.find(network_label)
        end
      end

      class Real
        include Shared

        # Clones a VM from a template or existing machine on your vSphere 
        # Server. Needs to be augmented to select network label and set
        # guest hostname. 
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'template_path'<~String> - *REQUIRED* The path to the machine you 
        #     want to clone FROM. (Example:
        #     "/Datacenter/DataCenterNameHere/FolderNameHere/VMNameHere")
        #   * 'name'<~String> - *REQUIRED* The VMName of the Destination  
        #   * 'dest_folder'<~String> - Destination Folder of where 'name' will
        #     be placed on your cluster.
        #   * 'power_on'<~Boolean> - Whether to power on machine after clone. 
        #     Defaults to true.
        #   * 'wait'<~Boolean> - Whether the method should wait for the virtual
        #     machine to close finish cloning before returning information from 
        #     vSphere. Returns the value of the machine if it finishes cloning 
        #     in 150 seconds (1m30s) else it returns nil. 'wait' Defaults to nil. 
        #     Saves a little time.
        #   * 'resource_pool'<~Array> - The resource pool on your datacenter 
        #     cluster you want to use. Only works with clusters within same
        #     same datacenter as where you're cloning from. Datacenter grabbed
        #     from template_path option. 
        #     Example: ['cluster_name_here','resource_pool_name_here']
        #   * 'datastore'<~String> - The datastore you'd like to use.
        #       (datacenterObj.datastoreFolder.find('name') in API)
        #   * 'transform'<~String> - Not documented - see http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.html
        #
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)

          # Comment needed
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Could not find VM template" }

          # Grab what datacenter we're dealing with
          self.datacenters
          # Ugly, sorry
          datacenter_obj = @datacenters[options['template_path'].split('/').tap{|a| a.shift 2}[0]]

          # Option['template_path']<~String>
          # Grab the folder Object for the Template
          template_folder = find_folder_obj(options['template_path'])
          # The template name.  The remaining elements are the folders in the
          # datacenter.
          template_name = options['template_path'].split('/').last
          # Now find the template itself using the efficient find method
          vm_mob_ref = template_folder.find(template_name, RbVmomi::VIM::VirtualMachine)

          # Option['dest_folder']<~String>
          # Grab the destination folder object if it exists else use cloned mach
          dest_folder = find_folder_obj(options['dest_folder'], false) if options.has_key?('dest_folder')
          dest_folder ||= vm_mob_ref.parent

          # Option['resource_pool']<~Array>
          # Now find _a_ resource pool to use for the clone if one is not specified
          if ( options.has_key?('resource_pool') && options['resource_pool'].is_a?(Array) && options['resource_pool'].length == 2 )
            cluster_name = options['resource_pool'][0]
            pool_name = options['resource_pool'][1]
            resource_pool = find_resource_pool_obj(datacenter_obj, cluster_name, pool_name)
          elsif ( vm_mob_ref.resourcePool == nil )
            # If the template is really a template then there is no associated resource pool,
            # so we need to find one using the template's parent host or cluster
            esx_host = vm_mob_ref.collect!('runtime.host')['runtime.host']
            # The parent of the ESX host itself is a ComputeResource which has a resourcePool
            resource_pool = esx_host.parent.resourcePool
          end
          # If the vm given did return a valid resource pool, default to using it for the clone.
          # Even if specific pools aren't implemented in this environment, we will still get back
          # at least the cluster or host we can pass on to the clone task
          # This catches if resource_pool option is set but comes back nil and if resourcePool is 
          # already set. 
          resource_pool ||= vm_mob_ref.resourcePool.nil? ? esx_host.parent.resourcePool : vm_mob_ref.resourcePool

          # Option['datastore']<~String>
          # Grab the datastore object if option is set
          datastore_obj = find_datastore_obj(datacenter_obj, options['datastore']) if options.has_key?('datastore')
          # confirm nil if nil or option is not set
          datastore_obj ||= nil

          # Begin Building Objects to CloneVM_Task - Below here is all action
          # on built parameters. 
          
          # Build VirtualMachineRelocateSpec
          relocation_spec=nil
          if ( options['linked_clone'] )
            # cribbed heavily from the rbvmomi clone_vm.rb
            # this chunk of code reconfigures the disk of the clone source to be read only,
            # and then creates a delta disk on top of that, this is required by the API in order to create
            # linked clondes
            disks = vm_mob_ref.config.hardware.device.select do |vm_device|
              vm_device.class == RbVmomi::VIM::VirtualDisk
            end
            disks.select{|vm_device| vm_device.backing.parent == nil}.each do |disk|
              disk_spec = {
                :deviceChange => [
                  {
                    :operation => :remove,
                    :device => disk
                  },
                  {
                    :operation => :add,
                    :fileOperation => :create,
                    :device => disk.dup.tap{|disk_backing|
                      disk_backing.backing = disk_backing.backing.dup;
                      disk_backing.backing.fileName = "[#{disk.backing.datastore.name}]";
                      disk_backing.backing.parent = disk.backing
                    }
                  },
                ]
              }
              vm_mob_ref.ReconfigVM_Task(:spec => disk_spec).wait_for_completion
            end
            # Next, create a Relocation Spec instance
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => datastore_obj,
                                                                      :pool => resource_pool,
                                                                      :diskMoveType => :moveChildMostDiskBacking)
          else
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => datastore_obj, 
                                                                      :pool => resource_pool,
                                                                      :transform => options['transform'] || 'sparse')
          end
          # And the clone specification
          clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocation_spec,
                                                            :powerOn  => options.has_key?('power_on') ? options['power_on'] : true,
                                                            :template => false)
          task = vm_mob_ref.CloneVM_Task(:folder => dest_folder,
                                         :name => options['name'],
                                         :spec => clone_spec)
          # Waiting for the VM to complete allows us to get the VirtulMachine
          # object of the new machine when it's done.  It is HIGHLY recommended
          # to set 'wait' => true if your app wants to wait.  Otherwise, you're
          # going to have to reload the server model over and over which
          # generates a lot of time consuming API calls to vmware.
          if options['wait'] then
            # REVISIT: It would be awesome to call a block passed to this
            # request to notify the application how far along in the process we
            # are.  I'm thinking of updating a progress bar, etc...
            new_vm = task.wait_for_completion
          else
            tries = 0
            new_vm = begin
              # Try and find the new VM (folder.find is quite efficient)
              dest_folder.find(options['name'], RbVmomi::VIM::VirtualMachine) or raise Fog::Vsphere::Errors::NotFound
            rescue Fog::Vsphere::Errors::NotFound
              tries += 1
              if tries <= 10 then
                sleep 15
                retry
              end
              nil
            end
          end

          # Return hash
          {
            'vm_ref'        => new_vm ? new_vm._ref : nil,
            'vm_attributes' => new_vm ? convert_vm_mob_ref_to_attr_hash(new_vm) : {},
            'task_ref'      => task._ref
          }
        end

      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Could not find VM template" }
          vm_mob_ref = list_virtual_machines['virtual_machines'].find(notfound) do |vm|
            vm['name'] == options['path'].split("/")[-1]
          end
          {
            'vm_ref'   => 'vm-123',
            'task_ref' => 'task-1234',
          }
        end

      end
    end
  end
end
