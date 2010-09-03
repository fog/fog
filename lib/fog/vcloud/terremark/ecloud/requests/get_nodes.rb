module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_nodes
        end

        module Mock

          #
          # Based off of:
          # http://support.theenterprisecloud.com/kb/default.asp?id=637&Lang=1&SID=
          #
          def get_nodes(nodes_uri)
            nodes_uri = ensure_unparsed(nodes_uri)
            service_uri = nodes_uri.gsub('/nodeServices','')
            ip, service = mock_ip_and_service_from_service_url(service_uri)
            if ip and service
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.NodeServices(ecloud_xmlns) {
                  service[:nodes].each do |node|
                    xml.NodeService {
                      xml.Id(node[:id])
                      xml.Href(node[:href])
                      xml.Name(node[:name])
                      xml.IpAddress(node[:ip_address])
                      xml.Port(node[:port])
                      xml.Enabled(node[:enabled])
                      xml.Description(node[:description])
                    }
                  end
                }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.nodeService+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
