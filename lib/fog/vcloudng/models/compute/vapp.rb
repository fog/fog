require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Vapp < Fog::Model
        
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :deployed, :type => :boolean
        attribute :status
        attribute :deployment_lease_in_seconds, :aliases => :LeaseSettingsSection, :squash => :DeploymentLeaseInSeconds
        attribute :storage_lease_in_seconds, :aliases => :LeaseSettingsSection, :squash => :StorageLeaseInSeconds
        attribute :startup_section, :aliases => :"ovf:StartupSection", :squash => :"ovf:Item"
        attribute :network_section, :aliases => :"ovf:NetworkSection", :squash => :"ovf:Network"
        attribute :network_config, :aliases => :NetworkConfigSection, :squash => :NetworkConfig
        attribute :owner, :aliases => :Owner, :squash => :User
        attribute :InMaintenanceMode, :type => :boolean
        
        def vms
          requires :id
          service.vms(:vapp_id => id)
        end

      end
    end
  end
end