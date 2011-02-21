module Fog
  module Ecloud
    class Compute
      class Network < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i, :Configuration, :Id

        attribute :name, :aliases => :Name
        #attribute :id, :aliases => :Id
        attribute :features, :aliases => :Features, :type => :array
        attribute :links, :aliases => :Link, :type => :array
        attribute :type
        attribute :gateway, :aliases => :GatewayAddress
        attribute :broadcast, :aliases => :BroadcastAddress
        attribute :address, :aliases => :Address
        attribute :rnat, :aliases => :RnatAddress
        attribute :extension_href, :aliases => :Href
        attribute :network_type, :aliases => :NetworkType
        attribute :vlan, :aliases => :Vlan
        attribute :friendly_name, :aliases => :FriendlyName

        def ips
          load_unless_loaded!
          Fog::Ecloud::Compute::Ips.new( :connection => connection,
               :href => links.detect { |link| link[:name] == "IP Addresses" }[:href] )
        end

        def rnat=(new_rnat)
          attributes[:rnat] = new_rnat
          @changed = true
        end

        def save
          if @changed
            connection.configure_network( extension_href, _compose_network_data )
          end
          true
        end

        def reload
          super
          merge_attributes(extension_data.body)
          self
        end

        private

        def extension_data
          connection.get_network_extensions( extensions_link[:href] )
        end

        def extensions_link
          links.detect { |link| link[:name] == name }
        end

        def _compose_network_data
          {
            :id => id,
            :href => extension_href,
            :name => name,
            :rnat => rnat,
            :address => address,
            :broadcast => broadcast,
            :gateway => gateway
          }
        end
      end
    end
  end
end
