module Fog
  module Compute
    class Vsphere

      module Shared
        private

        def vm_clone_check_options(options)
          required_options = %w{ path name }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.has_key? param
          end
          # The tap removes the leading empty string
          path_elements = options['path'].split('/').tap { |o| o.shift }
          first_folder = path_elements.shift
          if first_folder != 'Datacenters' then
            raise ArgumentError, "vm_clone path option must start with /Datacenters.  Got: #{options['path']}"
          end
          dc_name = path_elements.shift
          if not self.datacenters.include? dc_name then
            raise ArgumentError, "Datacenter #{dc_name} does not exist, only datacenters #{self.dacenters.join(",")} are accessible."
          end
          options
        end
      end

      class Real
        include Shared
        def vm_clone(options = {})
          raise ArgumentError, "config_json is a required parameter" unless options['path'] or options['vm_moid']
          # Option handling
          default_options = {
              'force'        => false,
              'linked_clone' => false,
              'power_on'     => true,
              'wait' => 1,
              'thin' => true
          }
          options = default_options.merge(options)

          if options['path']
            options = vm_clone_check_options(options)
            notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Could not find VM template" }
            # Find the template in the folder.  This is more efficient than
            # searching ALL VM's looking for the template.
            # Tap gets rid of the leading empty string and "Datacenters" element
            # and returns the array.
            path_elements = options['path'].split('/').tap { |ary| ary.shift 2 }
            # The DC name itself.
            template_dc = path_elements.shift
            # If the first path element contains "vm" this denotes the vmFolder
            # and needs to be shifted out
            path_elements.shift if path_elements[0] == 'vm'
            # The template name.  The remaining elements are the folders in the
            # datacenter.
            template_name = path_elements.pop
            # Make sure @datacenters is populated.  We need the instances from the Hash keys.
            self.datacenters
            # Get the datacenter managed object from the hash
            dc = @datacenters[template_dc]
            # Get the VM Folder (Group) efficiently
            vm_folder = dc.vmFolder
            # Walk the tree resetting the folder pointer as we go
            folder = path_elements.inject(vm_folder) do |current_folder, sub_folder_name|
              # JJM VIM::Folder#find appears to be quite efficient as it uses the
              # searchIndex It certainly appears to be faster than
              # VIM::Folder#inventory since that returns _all_ managed objects of
              # a certain type _and_ their properties.
              sub_folder = current_folder.find(sub_folder_name, RbVmomi::VIM::Folder)
              raise ArgumentError, "Could not descend into #{sub_folder_name}.  Please check your path." unless sub_folder
              sub_folder
            end

            # Now find the template itself using the efficient find method
            vm_mob_ref = folder.find(template_name, RbVmomi::VIM::VirtualMachine)
            # Now find _a_ resource pool of the template's host (REVISIT: We need
            # to support cloning into a specific RP)
          elsif options['vm_moid']
            vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          end

          if vm_mob_ref
            host_mob_ref = vm_mob_ref.collect!('runtime.host')['runtime.host']
          else
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference could not be found."
          end

          dc_mob_ref = get_parent_dc_by_vm_mob(vm_mob_ref)

          # The parent of the ESX host itself is a ComputeResource which has a resourcePool
          resource_pool = host_mob_ref.parent.resourcePool
          dest_datastores = host_mob_ref.datastore
          src_datastores = vm_mob_ref.datastore

          ds_mob_ref= nil
          ds_mob_ref = RbVmomi::VIM::Datastore.new(@connection, options['datastore_moid']) if options['datastore_moid']
          host_mob_ref = RbVmomi::VIM::HostSystem.new(@connection, options['host_moid']) if options['host_moid']
          resource_pool = RbVmomi::VIM::ResourcePool.new(@connection, options['rp_moid']) if options['rp_moid']
          cs_mob_ref = RbVmomi::VIM::ComputeResource.new(@connection, options['cluster_moid']) if options['cluster_moid']

          # argument of host and resource pool are prioritized over cluster since more concrete
          if cs_mob_ref
            if !(cs_mob_ref.host.include? host_mob_ref)|| !(get_rps_by_cs_mob(cs_mob_ref).include? resource_pool)
              raise Fog::Compute::Vsphere::NotFound, "Not matched arguments: host_moid, rp_moid, and cluster_moid"
            end
          end

          if ds_mob_ref && (src_datastores.size>1)
            linked_clone = false
          else
            set = dest_datastores & src_datastores
            linked_clone =(set == src_datastores )
            if ds_mob_ref
              linked_clone = linked_clone && (set.include? ds_mob_ref)
            end
          end

          relocation_spec=nil
          if ( linked_clone && options['linked_clone'] )
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
              task = vm_mob_ref.ReconfigVM_Task(:spec => disk_spec).
                  wait_for_task(task)
            end
            # Next, create a Relocation Spec instance
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => ds_mob_ref,
                                                                      :pool => resource_pool,
                                                                      :host => host_mob_ref,
                                                                      :diskMoveType => :moveChildMostDiskBacking)
          else
            disk = []
            disks = vm_mob_ref.config.hardware.device.select do |vm_device|
              vm_device.class == RbVmomi::VIM::VirtualDisk
            end
            disks.each do |disk_device|
              disk_locator = RbVmomi::VIM::VirtualMachineRelocateSpecDiskLocator.new
              disk_locator.datastore = ds_mob_ref
              backing_info = disk_device.backing.dup
              backing_info.datastore = ds_mob_ref
              if options['thin']
                backing_info.thinProvisioned = true
              end
              disk_locator.diskBackingInfo = backing_info
              disk_locator.diskId = disk_device.key
              disk << disk_locator
            end
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => ds_mob_ref,
                                                                      :pool => resource_pool,
                                                                      :host => host_mob_ref,
                                                                      :disk => disk,
                                                                      :transform => options['transform'] || 'sparse')
          end

          config = RbVmomi::VIM.VirtualMachineConfigSpec('numCPUs' => options['cpu'],
                                                         'memoryMB' => options['memory'])

          # And the clone specification
          clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocation_spec,
                                                            :powerOn  => options['power_on'] && true,
                                                            :template => false,
                                                            :config => config)
          task = vm_mob_ref.CloneVM_Task(:folder => dc_mob_ref.vmFolder, :name => options['name'], :spec => clone_spec)
          # Waiting for the VM to complete allows us to get the VirtulMachine
          # object of the new machine when it's done.  It is HIGHLY recommended
          # to set 'wait' => true if your app wants to wait.  Otherwise, you're
          # going to have to reload the server model over and over which
          # generates a lot of time consuming API calls to vmware.
          if options['wait'] then
            # REVISIT: It would be awesome to call a block passed to this
            # request to notify the application how far along in the process we
            # are.  I'm thinking of updating a progress bar, etc...
            new_vm = wait_for_task(task)
          else
            tries = 0
            new_vm = begin
                       # Try and find the new VM (folder.find is quite efficient)
              folder.find(options['name'], RbVmomi::VIM::VirtualMachine) or raise Fog::Vsphere::Errors::NotFound
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
              'task_ref'      => task._ref ,
              'cpu' =>  new_vm.summary.config.numCpu,
              'memory' => new_vm.summary.config.memorySizeMB
          }
        end

      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling
          default_options = {
              'force'        => false,
              'linked_clone' => false,
              'power_on'     => true,
              'wait' => 1
          }
          options = default_options.merge(options)
          options = vm_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Cloud not find VM template" }
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
