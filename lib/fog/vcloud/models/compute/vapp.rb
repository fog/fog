module Fog
  module Vcloud
    class Compute
      class Vapp < Fog::Vcloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :status
        attribute :description
        attribute :deployed, :type => :boolean
        attribute :children, :aliases => :Children, :squash => :Vm
        attribute :lease_settings, :aliases => :LeaseSettingsSection
        attribute :other_links, :aliases => :Link

        def servers
          @servers ||= Fog::Vcloud::Compute::Servers.
            new( :connection => connection,
                 :href => href,
                 :vapp => self
            )
        end
      end
    end
  end
end
