module Fog
  module Compute
    class Vsphere
      class Real
        def create_vm attributes = { }
          # build up vm configuration

          vm_cfg        = {
            :name         => attributes[:name],
            :guestId      => attributes[:guest_id],
            :version      => attributes[:hardware_version],
            :files        => { :vmPathName => vm_path_name(attributes) },
            :numCPUs      => attributes[:cpus],
            :numCoresPerSocket => attributes[:corespersocket],
            :memoryMB     => attributes[:memory_mb],
            :deviceChange => device_change(attributes),
            :extraConfig  => extra_config(attributes),
          }
          vm_cfg[:cpuHotAddEnabled] = attributes[:cpuHotAddEnabled] if attributes.key?(:cpuHotAddEnabled)
          vm_cfg[:memoryHotAddEnabled] = attributes[:memoryHotAddEnabled] if attributes.key?(:memoryHotAddEnabled)
          vm_cfg[:firmware] = attributes[:firmware] if attributes.key?(:firmware)
          vm_cfg[:bootOptions] = boot_options(attributes) if attributes.key?(:boot_order)
          resource_pool = if attributes[:resource_pool]
                            get_raw_resource_pool(attributes[:resource_pool], attributes[:cluster], attributes[:datacenter])
                          else
                            get_raw_cluster(attributes[:cluster], attributes[:datacenter]).resourcePool
                          end
          vmFolder      = get_raw_vmfolder(attributes[:path], attributes[:datacenter])
          vm            = vmFolder.CreateVM_Task(:config => vm_cfg, :pool => resource_pool).wait_for_completion
          vm.config.instanceUuid
        rescue => e
          raise e, "failed to create vm: #{e}"
        end

        private

        # this methods defines where the vm config files would be located,
        # by default we prefer to keep it at the same place the (first) vmdk is located
        def vm_path_name attributes
          datastore = attributes[:volumes].first.datastore unless attributes[:volumes].empty?
          datastore ||= 'datastore1'
          "[#{datastore}]"
        end

        def device_change attributes
          devices = []
          if (nics = attributes[:interfaces])
            devices << nics.map { |nic| create_interface(nic, nics.index(nic), :add, attributes) }
          end

          if (disks = attributes[:volumes])
            devices << create_controller(attributes[:scsi_controller]||attributes["scsi_controller"]||{})
            devices << disks.map { |disk| create_disk(disk, disks.index(disk)) }
          end
          devices.flatten
        end

        def boot_options attributes
          # NOTE: you must be using vsphere_rev 5.0 or greater to set boot_order
          # e.g. Fog::Compute.new(provider: "vsphere", vsphere_rev: "5.5", etc)
          RbVmomi::VIM::VirtualMachineBootOptions.new(
            :bootOrder => boot_order(attributes)
          )
        end

        def boot_order attributes
          # attributes[:boot_order] may be an array like this ['network', 'disk']
          # stating, that we want to prefer network boots over disk boots
          boot_order = []
          attributes[:boot_order].each do |boot_device|
            case boot_device
            when 'network'
              if nics = attributes[:interfaces]
                # key is based on 4000 + the interface index
                # we allow booting from all network interfaces, the first interface has the highest priority
                nics.each do |nic|
                  boot_order << RbVmomi::VIM::VirtualMachineBootOptionsBootableEthernetDevice.new(
                    :deviceKey => 4000 + nics.index(nic),
                  )
                end
              end
            when 'disk'
              if disks = attributes[:volumes]
                disks.each do |disk|
                  # we allow booting from all harddisks, the first disk has the highest priority
                  boot_order << RbVmomi::VIM::VirtualMachineBootOptionsBootableDiskDevice.new(
                    :deviceKey => disk.key || get_disk_device_key(disks.index(disk)),
                  )
                end
              end
            when 'cdrom'
              boot_order << RbVmomi::VIM::VirtualMachineBootOptionsBootableCdromDevice.new()
            when 'floppy'
              boot_order << RbVmomi::VIM::VirtualMachineBootOptionsBootableFloppyDevice.new()
            else
              raise "failed to create boot device because \"#{boot_device}\" is unknown"
            end
          end
          boot_order
        end

        def get_disk_device_key(index)
          # disk key is based on 2000 + the SCSI ID + the controller bus * 16
          # the scsi host adapter appears as SCSI ID 7, so we have to skip that
          # host adapter key is based on 1000 + bus id
          # fog assumes that there is only a single scsi controller, see device_change()
          if (index > 6) then
            _index = index + 1
          else
            _index = index
          end
          2000 + _index
        end

        def create_nic_backing nic, attributes
          raw_network = get_raw_network(nic.network, attributes[:datacenter], if nic.virtualswitch then nic.virtualswitch end)

          if raw_network.kind_of? RbVmomi::VIM::DistributedVirtualPortgroup
            RbVmomi::VIM.VirtualEthernetCardDistributedVirtualPortBackingInfo(
              :port => RbVmomi::VIM.DistributedVirtualSwitchPortConnection(
                :portgroupKey => raw_network.key,
                :switchUuid   => raw_network.config.distributedVirtualSwitch.uuid
              )
            )
          else
            RbVmomi::VIM.VirtualEthernetCardNetworkBackingInfo(:deviceName => nic.network)
          end
        end

        def create_interface nic, index = 0, operation = :add, attributes = {}
          {
            :operation => operation,
            :device    => nic.type.new(
              :key         => index,
              :deviceInfo  =>
                {
                  :label   => nic.name,
                  :summary => nic.summary,
                },
              :backing     => create_nic_backing(nic, attributes),
              :addressType => 'generated')
          }
        end

        def create_controller options=nil
          options=if options
                    controller_default_options.merge(Hash[options.map{|k,v| [k.to_sym,v] }])
                  else
                    controller_default_options
                  end
          controller_class=if options[:type].is_a? String then
                             Fog::Vsphere.class_from_string options[:type], "RbVmomi::VIM"
                           else
                             options[:type]
                           end
          {
            :operation => options[:operation],
            :device    => controller_class.new({
              :key       => options[:key],
              :busNumber => options[:bus_id],
              :sharedBus => controller_get_shared_from_options(options),
            })
          }
        end

        def controller_default_options
          {:operation => "add", :type => RbVmomi::VIM.VirtualLsiLogicController.class, :key => 1000, :bus_id => 0, :shared => false }
        end

        def controller_get_shared_from_options options
          if (options.key? :shared and options[:shared]==false) or not options.key? :shared then
            :noSharing
          elsif options[:shared]==true then
            :virtualSharing
          elsif options[:shared].is_a? String
            options[:shared]
          else
            :noSharing
          end
        end

        def create_disk disk, index = 0, operation = :add, controller_key = 1000
          if (index > 6) then
            _index = index + 1
          else
            _index = index
          end
          payload = {
            :operation     => operation,
            :fileOperation => operation == :add ? :create : :destroy,
            :device        => RbVmomi::VIM.VirtualDisk(
              :key           => disk.key || _index,
              :backing       => RbVmomi::VIM.VirtualDiskFlatVer2BackingInfo(
                :fileName        => "[#{disk.datastore}]",
                :diskMode        => disk.mode.to_sym,
                :thinProvisioned => disk.thin
              ),
              :controllerKey => controller_key,
              :unitNumber    => _index,
              :capacityInKB  => disk.size
            )
          }

          if operation == :add && disk.thin == 'false' && disk.eager_zero == 'true'
            payload[:device][:backing][:eagerlyScrub] = disk.eager_zero
          end

          payload
        end

        def extra_config attributes
          [
            {
              :key   => 'bios.bootOrder',
              :value => 'ethernet0'
            }
          ]
        end
      end

      class Mock
        def create_vm attributes = { }
        end
      end
    end
  end
end
