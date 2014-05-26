
module Fog
  module Compute
    class Vsphere
      class Real
        def get_vm_first_scsi_controller(vm_id)
          Fog::Compute::Vsphere::SCSIController.new(get_vm_first_scsi_controller_raw(vm_id))
        end

        def get_vm_first_scsi_controller_raw(vm_id)
          ctrl=get_vm_ref(vm_id).config.hardware.device.grep(RbVmomi::VIM::VirtualSCSIController).select{ | ctrl | ctrl.key == 1000 }.first
          {
            :type    => ctrl.class.to_s,
            :shared_bus  => ctrl.sharedBus.to_s,
            :unit_number => ctrl.scsiCtlrUnitNumber,
            :key => ctrl.key,
          }
        end
      end
      class Mock
        def get_vm_first_scsi_controller(vm_id)
        end
      end
    end
  end
end
