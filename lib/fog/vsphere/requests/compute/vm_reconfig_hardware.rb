module Fog
  module Compute
    class Vsphere
      class Real
        def vm_reconfig_hardware(options = {})
          raise ArgumentError, "hardware_spec is a required parameter" unless options.has_key? 'hardware_spec'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          task = vm_mob_ref.ReconfigVM_Task(:spec => RbVmomi::VIM.VirtualMachineConfigSpec(options['hardware_spec']))
          task.wait_for_completion
           { 'task_state' => task.info.state }
        end
      end

      class Mock
        def vm_reconfig_hardware(options = {})
          raise ArgumentError, "hardware_spec is a required parameter" unless options.has_key? 'hardware_spec'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state' => 'success' }
        end
      end
    end
  end
end
