module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_network_extensions
        end

        module Mock

          def get_network_extensions(network_uri)
            network_uri = ensure_unparsed(network_uri)
            type = "application/vnd.vmware.vcloud.network+xml"
            response = Excon::Response.new
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:extension_href] == network_uri }
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.Network(:xmlns => "urn:tmrk:eCloudExtensions-2.3", :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                  xml.Address(network[:name].split("/")[0])
                  xml.RnatAddress(network[:rnat])
                  xml.Href(network[:extension_href])
                  xml.Id(network[:id])
                  xml.Name(network[:name])
                  xml.GatewayAddress(network[:gateway])
                  xml.BroadcastAddress(IPAddr.new(network[:subnet]).to_range.last.to_s)
                }, { 'Content-Type' => type }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
