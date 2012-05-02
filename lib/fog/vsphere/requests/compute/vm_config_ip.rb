module Fog
  module Compute
    class Vsphere

      module Shared
        private


      end

      class Real
        include Shared

        def vm_config_ip(options = {})
          raise ArgumentError, "config_json is a required parameter" unless options.has_key? 'config_json'
          raise ArgumentError, "vm_moid is a required parameter" unless options.has_key? 'vm_moid'
          vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          ovs = RbVmomi::VIM.OptionValue(:key=>"machine.id", :value=> options['config_json'])
          ip_config_spec = RbVmomi::VIM.VirtualMachineConfigSpec(:extraConfig => [ovs])
          task = vm_mob_ref.ReconfigVM_Task(:spec => ip_config_spec )
          task.wait_for_completion
          { 'task_state' => task.info.state }
        end

      end
    end
  end
end
