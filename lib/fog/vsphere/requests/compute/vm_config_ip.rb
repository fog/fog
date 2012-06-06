# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
#      Licensed under the Apache License, Version 2.0 (the "License");
#
#   you may not use this file except in compliance with the License.
#
#   You may obtain a copy of the License at
#
#
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#
#
#
#   Unless required by applicable law or agreed to in writing, software
#
#   distributed under the License is distributed on an "AS IS" BASIS,
#
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
#   See the License for the specific language governing permissions and
#
#   limitations under the License.


module Fog
  module Compute
    class Vsphere

      class Real
        include Shared

        def vm_config_ip(options = {})
          raise ArgumentError, "config_json is a required parameter" unless options.has_key? 'config_json'
          raise ArgumentError, "vm_moid is a required parameter" unless options.has_key? 'vm_moid'
          vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          ovs = RbVmomi::VIM.OptionValue(:key=>"machine.id", :value=> options['config_json'])
          ip_config_spec = RbVmomi::VIM.VirtualMachineConfigSpec(:extraConfig => [ovs])
          task = vm_mob_ref.ReconfigVM_Task(:spec => ip_config_spec )
          wait_for_task(task)
          { 'task_state' => task.info.state }
        end

      end
    end
  end
end
