#
#   Copyright (c) 2013 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

module Fog
  module Compute
    class Vsphere
      class Real

        def vm_config_vhm(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          raise ArgumentError, "vhm_enable is a required parameter" unless options.has_key? 'vhm_enable'

          Fog::Logger.debug("parameters to config vhm: #{options.inspect}")

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          vhm_info = []
          { "vhmInfo.serengeti.uuid" => "serengeti_uuid",
            "vhmInfo.masterVM.uuid" => "masterVM_uuid",
            "vhmInfo.masterVM.moid" => "masterVM_moid",
            "vhmInfo.elastic" => "vm_elastic"
          }.each do |dst, src|
            if options.has_key?(src) && !options[src].nil?
              vhm_info << RbVmomi::VIM::OptionValue(:key => dst, :value => options[src].to_s)
            end
          end

          if options.has_key?("masterVM_moid") and options.has_key?("self_moid") and options["masterVM_moid"] == options["self_moid"]
            vhm_info << RbVmomi::VIM::OptionValue(:key => "vhmInfo.vhm.enable", :value => options["vhm_enable"].to_s)
            if !options["vhm_min_num"].nil?
              vhm_info << RbVmomi::VIM::OptionValue(:key => "vhmInfo.min.computeNodesNum", :value => options["vhm_min_num"].to_s)
            end
          end

          config = RbVmomi::VIM::VirtualMachineConfigSpec(:extraConfig => vhm_info) 

          task = vm_mob_ref.ReconfigVM_Task(:spec => config)
          wait_for_task(task)

          { 'task_state' => task.info.state }
        end

      end

      class Mock

        def vm_config_vhm(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state' => 'success' }
        end

      end
    end
  end
end
