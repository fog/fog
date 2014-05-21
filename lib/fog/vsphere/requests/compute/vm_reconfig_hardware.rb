module Fog
  module Compute
    class Vsphere
      class Real
        def vm_reconfig_hardware(options = {})
          raise ArgumentError, "hardware_spec is a required parameter" unless options.key? 'hardware_spec'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          vm_mob_ref = get_vm_ref(options['instance_uuid'])
          task = vm_mob_ref.ReconfigVM_Task(:spec => RbVmomi::VIM.VirtualMachineConfigSpec(options['hardware_spec']))
          task.wait_for_completion
           { 'task_state' => task.info.state }
        end
      end

      class Mock
        def vm_reconfig_hardware(options = {})
          raise ArgumentError, "hardware_spec is a required parameter" unless options.key? 'hardware_spec'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          { 'task_state' => 'success' }
        end
      end
    end
  end
end
