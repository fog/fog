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
            new( :connection => connection,
                 :href => href,
                 :vapp => self
            )
        end

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
            new( :connection => connection,
                 :href => href
            )
        end
      end
    end
  end
end
