module Fog
  module Compute
    class Vsphere
      module Shared
        private
        def vm_clone_check_options(options)
          default_options = {
            'force'        => false,
            'linked_clone' => false,
            'nic_type' => 'VirtualE1000',
          }
          options = default_options.merge(options)
          # Backwards compat for "path" option
          options["template_path"] ||= options["path"]
          options["path"] ||= options["template_path"]
          required_options = %w{ datacenter template_path name }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.key? param
          end
          raise Fog::Compute::Vsphere::NotFound, "Datacenter #{options["datacenter"]} Doesn't Exist!" unless get_datacenter(options["datacenter"])
          raise Fog::Compute::Vsphere::NotFound, "Template #{options["template_path"]} Doesn't Exist!" unless get_virtual_machine(options["template_path"], options["datacenter"])
          options
        end
      end

      class Real
        include Shared

        # Clones a VM from a template or existing machine on your vSphere
        # Server.
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'datacenter'<~String> - *REQUIRED* Datacenter name your cloning
        #     in. Make sure this datacenter exists, should if you're using
        #     the clone function in server.rb model.
        #   * 'template_path'<~String> - *REQUIRED* The path to the machine you
        #     want to clone FROM. Relative to Datacenter (Example:
        #     "FolderNameHere/VMNameHere")
        #   * 'name'<~String> - *REQUIRED* The VMName of the Destination
        #   * 'dest_folder'<~String> - Destination Folder of where 'name' will
        #     be placed on your cluster. Relative Path to Datacenter E.G.
        #     "FolderPlaceHere/anotherSub Folder/onemore"
        #   * 'power_on'<~Boolean> - Whether to power on machine after clone.
        #     Defaults to true.
        #   * 'wait'<~Boolean> - Whether the method should wait for the virtual
        #     machine to finish cloning before returning information from
        #     vSphere. Broken right now as you cannot return a model of a serer
        #     that isn't finished cloning. Defaults to True
        #   * 'resource_pool'<~Array> - The resource pool on your datacenter
        #     cluster you want to use. Only works with clusters within same
        #     same datacenter as where you're cloning from. Datacenter grabbed
        #     from template_path option.
        #     Example: ['cluster_name_here','resource_pool_name_here']
        #   * 'datastore'<~String> - The datastore you'd like to use.
        #       (datacenterObj.datastoreFolder.find('name') in API)
        #   * 'transform'<~String> - Not documented - see http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.html
        #   * 'numCPUs'<~Integer> - the number of Virtual CPUs of the Destination VM
        #   * 'memoryMB'<~Integer> - the size of memory of the Destination VM in MB
        #   * customization_spec<~Hash>: Options are marked as required if you
        #     use this customization_spec. Static IP Settings not configured.
        #     This only support cloning and setting DHCP on the first interface
        #     * 'domain'<~String> - *REQUIRED* This is put into
        #       /etc/resolve.conf (we hope)
        #     * 'hostname'<~String> - Hostname of the Guest Os - default is
        #       options['name']
        #     * 'hw_utc_clock'<~Boolean> - *REQUIRED* Is hardware clock UTC?
        #       Default true
        #     * 'time_zone'<~String> - *REQUIRED* Only valid linux options
        #       are valid - example: 'America/Denver'
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)

          # Added for people still using options['path']
          template_path = options['path'] || options['template_path']

          # Options['template_path']<~String>
          # Added for people still using options['path']
          template_path = options['path'] || options['template_path']
          # Now find the template itself using the efficient find method
          vm_mob_ref = get_vm_ref(template_path, options['datacenter'])

          # Options['dest_folder']<~String>
          # Grab the destination folder object if it exists else use cloned mach
          dest_folder_path = options.fetch('dest_folder','/') # default to root path ({dc_name}/vm/)
          dest_folder = get_raw_vmfolder(dest_folder_path, options['datacenter'])

          # Options['resource_pool']<~Array>
          # Now find _a_ resource pool to use for the clone if one is not specified
          if ( options.key?('resource_pool') && options['resource_pool'].is_a?(Array) && options['resource_pool'].length == 2 )
            cluster_name = options['resource_pool'][0]
            pool_name = options['resource_pool'][1]
            resource_pool = get_raw_resource_pool(pool_name, cluster_name, options['datacenter'])
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

          # Options['datastore']<~String>
          # Grab the datastore object if option is set
          datastore_obj = get_raw_datastore(options['datastore'], options['datacenter']) if options.key?('datastore')
          # confirm nil if nil or option is not set
          datastore_obj ||= nil
          virtual_machine_config_spec = RbVmomi::VIM::VirtualMachineConfigSpec()

          # Options['network']
          # Build up the config spec
          if ( options.key?('network_label') )
            config_spec_operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation('edit')
            # Get the portgroup and handle it from there.
            network = get_raw_network(options['network_label'],options['datacenter'])
            if ( network.kind_of? RbVmomi::VIM::DistributedVirtualPortgroup)
                # Create the NIC backing for the distributed virtual portgroup
                nic_backing_info = RbVmomi::VIM::VirtualEthernetCardDistributedVirtualPortBackingInfo(
                    :port => RbVmomi::VIM::DistributedVirtualSwitchPortConnection( 
                                                                                  :portgroupKey => network.key, 
                                                                                  :switchUuid => network.config.distributedVirtualSwitch.uuid
                                                                                 ) 
                )
            else
                # Otherwise it's a non distributed port group
                nic_backing_info = RbVmomi::VIM::VirtualEthernetCardNetworkBackingInfo(:deviceName => options['network_label'])
            end
            connectable = RbVmomi::VIM::VirtualDeviceConnectInfo(
              :allowGuestControl => true,
              :connected => true,
              :startConnected => true)
            device = RbVmomi::VIM.public_send "#{options['nic_type']}",
              :backing => nic_backing_info,
              :deviceInfo => RbVmomi::VIM::Description(:label => "Network adapter 1", :summary => options['network_label']),
              :key => options['network_adapter_device_key'],
              :connectable => connectable
            device_spec = RbVmomi::VIM::VirtualDeviceConfigSpec(
              :operation => config_spec_operation,
              :device => device)
            virtual_machine_config_spec.deviceChange = [device_spec]
          end
          # Options['numCPUs'] or Options['memoryMB']
          # Build up the specification for Hardware, for more details see ____________
          # https://github.com/rlane/rbvmomi/blob/master/test/test_serialization.rb
          # http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.ConfigSpec.html
          # FIXME: pad this out with the rest of the useful things in VirtualMachineConfigSpec
          virtual_machine_config_spec.numCPUs = options['numCPUs'] if  ( options.key?('numCPUs') )
          virtual_machine_config_spec.memoryMB = options['memoryMB'] if ( options.key?('memoryMB') )
          # Options['customization_spec']
          # Build up all the crappy tiered objects like the perl method
          # Collect your variables ifset (writing at 11pm revist me)
          # * domain <~String> - *REQUIRED* - Sets the server's domain for customization
          # * dnsSuffixList <~Array> - Optional - Sets the dns search paths in resolv - Example: ["dev.example.com", "example.com"]
          # * ipsettings <~Hash> - Optional - If not set defaults to dhcp
          #  * ip <~String> - *REQUIRED* Sets the ip address of the VM - Example: 10.0.0.10
          #  * dnsServerList <~Array> - Optional - Sets the nameservers in resolv - Example: ["10.0.0.2", "10.0.0.3"]
          #  * gateway <~Array> - Optional - Sets the gateway for the interface - Example: ["10.0.0.1"]
          #  * subnetMask <~String> - *REQUIRED* - Set the netmask of the interface - Example: "255.255.255.0"
          #    For other ip settings options see http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.customization.IPSettings.html
          if ( options.key?('customization_spec') )
            cust_options = options['customization_spec']
            if cust_options.key?("ipsettings")
              raise ArgumentError, "ip and subnetMask is required for static ip" unless cust_options["ipsettings"].key?("ip") and
                                                                                        cust_options["ipsettings"].key?("subnetMask")
            end
            raise ArgumentError, "domain is required" unless cust_options.key?("domain")
            cust_domain = cust_options['domain']
            if cust_options.key?("ipsettings")
              cust_ip_settings = RbVmomi::VIM::CustomizationIPSettings.new(cust_options["ipsettings"])
              cust_ip_settings.ip = RbVmomi::VIM::CustomizationFixedIp("ipAddress" => cust_options["ipsettings"]["ip"])
              cust_ip_settings.gateway = cust_options['ipsettings']['gateway']
            end
            cust_ip_settings ||= RbVmomi::VIM::CustomizationIPSettings.new("ip" => RbVmomi::VIM::CustomizationDhcpIpGenerator.new())
            cust_ip_settings.dnsDomain = cust_domain
            cust_global_ip_settings = RbVmomi::VIM::CustomizationGlobalIPSettings.new
            cust_global_ip_settings.dnsServerList = cust_ip_settings.dnsServerList
            cust_global_ip_settings.dnsSuffixList = cust_options['dnsSuffixList'] || [cust_domain]
            cust_hostname = RbVmomi::VIM::CustomizationFixedName.new(:name => cust_options['hostname']) if cust_options.key?('hostname')
            cust_hostname ||= RbVmomi::VIM::CustomizationFixedName.new(:name => options['name'])
            cust_hwclockutc = cust_options['hw_clock_utc']
            cust_timezone = cust_options['time_zone']
            # Start Building objects
            # Build the CustomizationLinuxPrep Object
            cust_prep = RbVmomi::VIM::CustomizationLinuxPrep.new(
              :domain => cust_domain,
              :hostName => cust_hostname,
              :hwClockUTC => cust_hwclockutc,
              :timeZone => cust_timezone)
            # Build the Custom Adapter Mapping Supports only one eth right now
            cust_adapter_mapping = [RbVmomi::VIM::CustomizationAdapterMapping.new("adapter" => cust_ip_settings)]
            # Build the customization Spec
            customization_spec = RbVmomi::VIM::CustomizationSpec.new(
              :identity => cust_prep,
              :globalIPSettings => cust_global_ip_settings,
              :nicSettingMap => cust_adapter_mapping)
          end
          customization_spec ||= nil

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
                                                            :config => virtual_machine_config_spec,
                                                            :customization => customization_spec,
                                                            :powerOn  => options.key?('power_on') ? options['power_on'] : true,
                                                            :template => false)

          # Perform the actual Clone Task
          task = vm_mob_ref.CloneVM_Task(:folder => dest_folder,
                                         :name => options['name'],
                                         :spec => clone_spec)
          # Waiting for the VM to complete allows us to get the VirtulMachine
          # object of the new machine when it's done.  It is HIGHLY recommended
          # to set 'wait' => true if your app wants to wait.  Otherwise, you're
          # going to have to reload the server model over and over which
          # generates a lot of time consuming API calls to vmware.
          if options.fetch('wait', true) then
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
            'new_vm'        => new_vm ? convert_vm_mob_ref_to_attr_hash(new_vm) : nil,
            'task_ref'      => task._ref
          }
        end
      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling TODO Needs better method of checking
          options = vm_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Could not find VM template" }
          template = list_virtual_machines.find(notfound) do |vm|
            vm['name'] == options['template_path'].split("/")[-1]
          end

          # generate a random id
          id = [8,4,4,4,12].map{|i| Fog::Mock.random_hex(i)}.join("-")
          new_vm = template.clone.merge({
            "name" => options['name'],
            "id" => id,
            "instance_uuid" => id,
            "path" => "/Datacenters/#{options['datacenter']}/#{options['dest_folder'] ? options['dest_folder']+"/" : ""}#{options['name']}"
          })
          self.data[:servers][id] = new_vm

          {
            'vm_ref'   => "vm-#{Fog::Mock.random_numbers(3)}",
            'new_vm'   => new_vm,
            'task_ref' => "task-#{Fog::Mock.random_numbers(4)}",
          }
        end
      end
    end
  end
end
