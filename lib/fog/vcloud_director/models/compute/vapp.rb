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
        
        
      end
    end
  end
end