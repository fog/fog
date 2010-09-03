module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_node
        end

        module Mock

          #
          # Based on http://support.theenterprisecloud.com/kb/default.asp?id=641&Lang=1&SID=
          #
          #
          #
          def mock_node_service_response(node, xmlns)
            xml = Builder::XmlMarkup.new
            xml.NodeService(xmlns) {
              xml.Id(node[:id])
              xml.Href(node[:href])
              xml.Name(node[:name])
              xml.IpAddress(node[:ip_address])
              xml.Port(node[:port])
              xml.Enabled(node[:enabled])
              xml.Description(node[:description])
            }
          end

          def get_node(node_uri)

            node_uri = ensure_unparsed(node_uri)

            if node = mock_node_from_url(node_uri)
              xml = Builder::XmlMarkup.new
              mock_it 200, mock_node_service_response(node, ecloud_xmlns), { 'Content-Type' => 'application/vnd.tmrk.ecloud.nodeService+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
