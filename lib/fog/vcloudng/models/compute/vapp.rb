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
        attribute :lease_setting_section, :aliases => :LeaseSettingsSection
        attribute :startup_section, :aliases => :"ovf:StartupSection"
        attribute :network_section, :aliases => :"ovf:NetworkSection"
        attribute :network_config, :aliases => :NetworkConfigSection, :squash => :NetworkConfig
        attribute :owner, :aliases => :Owner, :squash => :name
        attribute :InMaintenanceMode, :type => :boolean
        attribute :vms, :aliases => :Children

        
      end
    end
  end
end