require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class VappTemplate < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :status
        attribute :lease_settings, :aliases => :LeaseSettingsSection
        attribute :network_section, :aliases => :"ovf:NetworkSection", :squash => :"ovf:Network"
        attribute :network_config, :aliases => :NetworkConfigSection, :squash => :NetworkConfig
        attribute :owner, :aliases => :Owner, :squash => :User

        def vms
          requires :id
          service.template_vms(:vapp_template => self)
        end
      end
    end
  end
end