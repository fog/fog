module Fog
  module Compute
    class Vsphere
      class Real
        def vm_reconfig_disk(options = {})
          raise ArgumentError, "size is a required parameter" unless options.has_key? 'size'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          vm_disks = get_vm_ref(options['instance_uuid']).disks
          if options.has_key? 'disk_uuid'
            if options['disk_uuid']!=nil
              virtual_disk = vm_disks.select!{|disk| disk.backing.uuid == options['disk_uuid']}
            end
          else            
            virtual_disk = vm_disks.first
          end
                            
          if virtual_disk
            virtual_disk.capacityInKB = options['size'] 
            virtual_disk.backing.thinProvisioned = options['thinProvisioned'] || false            
            device_cfg = RbVmomi::VIM::VirtualDeviceConfigSpec(
              :operation=>RbVmomi::VIM::VirtualDeviceConfigSpecOperation('edit'),
              :device => virtual_disk
            )
          else
            device_cfg = RbVmomi::VIM::VirtualDeviceConfigSpec(
              :operation => :add,
              :fileOperation => :create,
              :device => RbVmomi::VIM.VirtualDisk(
              :key => 1,
              :backing => RbVmomi::VIM.VirtualDiskFlatVer2BackingInfo(
                :fileName => "#{vm_disks.last.backing.fileName}.#{vm_disks.last.unitNumber + 1}",
                :diskMode => :persistent,
                :thinProvisioned => true
              ),
              :controllerKey => 1000,
              :unitNumber => vm_disks.last.unitNumber + 1,
              :capacityInKB => options['size']
              )
            )
          end
          hardware_spec={:deviceChange => [device_cfg]}

          vm_reconfig_hardware('instance_uuid' => options['instance_uuid'], 'hardware_spec' => hardware_spec )
        end
      end

      class Mock
        def vm_reconfig_disk(options = {})        
          raise ArgumentError, "size is a required parameter" unless options.has_key? 'size'
          raise ArgumentError, "disk uuid is a required parameter" unless options.has_key? 'disk_uuid'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          hardware_spec={}
          vm_reconfig_hardware('instance_uuid' => options['instance_uuid'], 'hardware_spec' => hardware_spec )
        end
      end
    end
  end
end
