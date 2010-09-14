#
# AFAICT this is basically undocumented ATM - 6/18/2010 - freeformz
#

module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_network_ip
        end

        class Mock

          def get_network_ip(ip_uri)
            response = Excon::Response.new
            ip_id = ip_uri.split("/").last
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| IPAddr.new(network[:subnet]).to_range.map { |ip| ip.to_s.gsub('.','') }.include?(ip_id) }
              ip = IPAddr.new(network[:subnet]).to_range.detect { |ip| ip.to_s.gsub('.','') == ip_id }
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.IpAddress(ecloud_xmlns) {
                  xml.Id( ip_id )
                  xml.Href( ip_uri.to_s )
                  xml.Name( ip.to_s )
                  if network[:ips].has_key?(ip.to_s)
                    xml.Status( "Assigned" )
                    xml.Server( network[:ips][ip.to_s] )
                  else
                    xml.Status( "Available" )
                  end
                },
                { 'Content-Type' => 'application/vnd.tmrk.ecloud.ip+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end

        end
      end
    end
  end
end
