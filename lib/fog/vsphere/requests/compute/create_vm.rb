module Fog
  module Compute
    class Vsphere
      class Real
        def create_vm attributes = { }
          # build up vm configuration

          vm_cfg        = {
            :name         => attributes[:name],
            :guestId      => attributes[:guest_id],
            :files        => { :vmPathName => vm_path_name(attributes) },
            :numCPUs      => attributes[:cpus],
            :memoryMB     => attributes[:memory_mb],
            :deviceChange => device_change(attributes),
            :extraConfig  => extra_config(attributes),
          }
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
            devices << nics.map { |nic| create_interface(nic, nics.index(nic)) }
          end

          if (disks = attributes[:volumes])
            devices << create_controller
            devices << disks.map { |disk| create_disk(disk, disks.index(disk)) }
          end
          devices.flatten
        end

        def create_interface nic, index = 0, operation = :add
          {
            :operation => operation,
            :device    => nic.type.new(
              :key         => index,
              :deviceInfo  =>
                {
                  :label   => nic.name,
                  :summary => nic.summary,
                },
              :backing     => RbVmomi::VIM.VirtualEthernetCardNetworkBackingInfo(:deviceName => nic.network),
              :addressType => 'generated')
          }
        end

        def create_controller operation = :add, controller_key = 1000, bus_id = 0
          {
            :operation => operation,
            :device    => RbVmomi::VIM.VirtualLsiLogicController(
              :key       => controller_key,
              :busNumber => bus_id,
              :sharedBus => :noSharing
            )
          }
        end

        def create_disk disk, index = 0, operation = :add, controller_key = 1000, unit_id = 0
          {
            :operation     => operation,
            :fileOperation => :create,
            :device        => RbVmomi::VIM.VirtualDisk(
              :key           => index,
              :backing       => RbVmomi::VIM.VirtualDiskFlatVer2BackingInfo(
                :fileName        => "[#{disk.datastore}]",
                :diskMode        => disk.mode.to_sym,
                :thinProvisioned => disk.thin
              ),
              :controllerKey => controller_key,
              :unitNumber    => unit_id,
              :capacityInKB  => disk.size
            )
          }
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