require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Vapp < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :deployed, :type => :boolean
        attribute :status
        attribute :lease_settings, :aliases => :LeaseSettingsSection
        attribute :network_section, :aliases => :"ovf:NetworkSection", :squash => :"ovf:Network"
        attribute :network_config, :aliases => :NetworkConfigSection, :squash => :NetworkConfig
        attribute :owner, :aliases => :Owner, :squash => :User
        attribute :InMaintenanceMode, :type => :boolean

        def vms
          requires :id
          service.vms(:vapp => self)
        end

        def tags
          requires :id
          service.tags(:vm => self)
        end

        def custom_fields
          requires :id
          service.custom_fields( :vapp => self)
        end

        # @param [String] action The specified action is applied to all virtual
        #   machines in the vApp. All values other than **default** ignore
        #   actions, order, and delay specified in the StartupSection. One of:
        # * powerOff (Power off the virtual machines. This is the default
        #   action if this attribute is missing or empty)
        # * suspend (Suspend the virtual machines)
        # * shutdown (Shut down the virtual machines)
        # * force (Attempt to power off the virtual machines. Failures in
        #   undeploying the virtual machine or associated networks are ignored.
        #   All references to the vApp and its virtual machines are removed
        #   from the database)
        # * default (Use the actions, order, and delay specified in the
        #   StartupSection)
        def undeploy(action='powerOff')
          begin
            response = service.post_undeploy_vapp(id, :UndeployPowerAction => action)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Power off all VMs in the vApp.
        def power_off
          requires :id
          begin
            response = service.post_power_off_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Power on all VMs in the vApp.
        def power_on
          requires :id
          begin
            response = service.post_power_on_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Reboot all VMs in the vApp.
        def reboot
          requires :id
          begin
            response = service.post_reboot_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Reset all VMs in the vApp.
        def reset
          requires :id
          begin
            response = service.post_reset_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Shut down all VMs in the vApp.
        def shutdown
          requires :id
          begin
            response = service.post_shutdown_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        # Suspend all VMs in the vApp.
        def suspend
          requires :id
          begin
            response = service.post_suspend_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end

        def destroy
          requires :id
          begin
            response = service.delete_vapp(id)
          rescue Fog::Compute::VcloudDirector::BadRequest => ex
            Fog::Logger.debug(ex.message)
            return false
          end
          service.process_task(response.body)
        end
      end
    end
  end
end
