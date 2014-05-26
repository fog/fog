require 'fog/vcloud/models/compute/helpers/status'
module Fog
  module Vcloud
    class Compute
      class Vapp < Fog::Vcloud::Model
        include Fog::Vcloud::Compute::Helpers::Status

        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :status
        attribute :description, :aliases => :Description
        attribute :deployed, :type => :boolean

        attribute :children, :aliases => :Children, :squash => :Vm
        attribute :lease_settings, :aliases => :LeaseSettingsSection

        attribute :network_configs, :aliases => :NetworkConfigSection

        has_up :vdc

        def servers
          @servers ||= Fog::Vcloud::Compute::Servers.
            new( :service => service,
                 :href => href,
                 :vapp => self
            )
        end

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
            new( :service => service,
                 :href => href
            )
        end

        def ready?
          reload_status # always ensure we have the correct status
          status != '0'
        end

        private
        def reload_status
          vapp = service.get_vapp(href)
          self.status = vapp.status
        end
      end
    end
  end
end
