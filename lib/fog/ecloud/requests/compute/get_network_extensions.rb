module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_network_extensions
      end

      class Mock

        def get_network_extensions(network_extension_uri)
          if network_extension = mock_data.network_extension_from_href(ensure_unparsed(network_extension_uri))
            xml = Builder::XmlMarkup.new
            mock_it 200, xml.Network(ecloud_xmlns) {
              xml.Address network_extension.address
              xml.RnatAddress network_extension.rnat
              xml.Href network_extension.href
              xml.Id network_extension.object_id
              xml.Name network_extension.name
              xml.GatewayAddress network_extension.gateway
              xml.BroadcastAddress network_extension.broadcast
              xml.NetworkType network_extension.type
              xml.Vlan network_extension.vlan
              xml.FriendlyName network_extension.friendly_name
            }, { 'Content-Type' => "application/vnd.tmrk.ecloud.network+xml" }
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end
    end
  end
end
