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

        def vm_cap_HA(options = {})
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


        def vm_disable_HA(options = {})
         raise ArgumentError, "Must pass a vm_moid option" unless options['vm_moid']
         vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
         cs_mob_ref = get_parent_cs_by_vm_mob(vm_mob_ref)
         ha_enable = vm_cap_HA('vm_moid' => options['vm_moid'])
         if !ha_enable
           return { 'task_state' => 'error'}
         end

         das_vm_priority = nil
         vm_das_configs = cs_mob_ref.configuration.dasVmConfig
         if vm_das_configs
           vm_das_config = vm_das_configs.find{|d| d[:key]._ref.to_s == options['vm_moid']}
         end
         if vm_das_config && vm_das_config.dasSettings
           das_vm_priority = vm_das_config.dasSettings.restartPriority
         end
         if das_vm_priority == "disabled"
           return  { 'task_state' => 'success' }
         end
         vm_ha_spec_info = RbVmomi::VIM::ClusterDasVmConfigInfo(
             :key=>vm_mob_ref,
             :restartPriority => RbVmomi::VIM::DasVmPriority("disabled")
         )
         vm_ha_spec = RbVmomi::VIM::ClusterDasVmConfigSpec(
             :operation=>RbVmomi::VIM::ArrayUpdateOperation("add"),
             :info=>vm_ha_spec_info
         )
         cluster_config_spec = RbVmomi::VIM::ClusterConfigSpec(:dasConfig=>cs_mob_ref.configuration.dasConfig, :dasVmConfigSpec=>[vm_ha_spec])
         task =cs_mob_ref.ReconfigureCluster_Task(:spec => cluster_config_spec,:modify=>false )
         task.wait_for_completion
         { 'task_state' => task.info.state }
       end

      end
    end
  end
end
