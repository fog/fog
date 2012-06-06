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

      module Shared
        private

        def get_parent_cs_by_vm_mob(vm_mob_ref)
          mob_ref = vm_mob_ref.resourcePool.owner
          while !(mob_ref.kind_of? RbVmomi::VIM::ComputeResource)
            mob_ref = mob_ref.parent
          end
          mob_ref
        end

      end

      class Real
        include Shared

        def is_vm_in_ha_cluster(options = {})
          raise ArgumentError, "Must pass a vm_moid option" unless options['vm_moid']
          vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          cs_mob_ref = get_parent_cs_by_vm_mob(vm_mob_ref)
          if cs_mob_ref.configuration.dasConfig
            ha_enable = cs_mob_ref.configuration.dasConfig.enabled
          else
            ha_enable = false
          end
          ha_enable
        end


        def vm_disable_ha(options = {})
          raise ArgumentError, "Must pass a vm_moid option" unless options['vm_moid']
          vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          cs_mob_ref = get_parent_cs_by_vm_mob(vm_mob_ref)
          ha_enable = is_vm_in_ha_cluster('vm_moid' => options['vm_moid'])
          if !ha_enable
            return { 'task_state' => 'error'}
          end

          das_vm_priority = nil
          vm_das_config = nil
          vm_ha_spec = nil

          vm_das_configs = cs_mob_ref.configuration.dasVmConfig


          vm_das_configs.each{|d|
            if d[:key]._ref.to_s == options['vm_moid']
              vm_das_config = d

              if vm_das_config #&& vm_das_config.dasSettings
                das_vm_priority = vm_das_config.restartPriority
              end

              if das_vm_priority && das_vm_priority == "disabled"
                return  { 'task_state' => 'success' }
              else
                vm_ha_spec_info = RbVmomi::VIM::ClusterDasVmConfigInfo(
                    :key=>vm_mob_ref,
                    :restartPriority => RbVmomi::VIM::DasVmPriority("disabled")
                )
                vm_ha_spec = RbVmomi::VIM::ClusterDasVmConfigSpec(
                    :operation=>RbVmomi::VIM::ArrayUpdateOperation("edit"),
                    :info=>vm_ha_spec_info
                )
              end

              break

            end

          }

          if vm_ha_spec.nil?
            vm_ha_spec_info = RbVmomi::VIM::ClusterDasVmConfigInfo(
                :key=>vm_mob_ref,
                :restartPriority => RbVmomi::VIM::DasVmPriority("disabled")
            )
            vm_ha_spec = RbVmomi::VIM::ClusterDasVmConfigSpec(
                :operation=>RbVmomi::VIM::ArrayUpdateOperation("add"),
                :info=>vm_ha_spec_info
            )
          end

          cluster_config_spec = RbVmomi::VIM::ClusterConfigSpec(
              :dasConfig=>cs_mob_ref.configuration.dasConfig,
              :drsConfig => cs_mob_ref.configuration.drsConfig,
              :dasVmConfigSpec=> [vm_ha_spec]
          )
          task =cs_mob_ref.ReconfigureCluster_Task(:spec => cluster_config_spec,:modify=>true )
          wait_for_task(task)
          { 'task_state' => task.info.state }
        end

      end
    end
  end
end
