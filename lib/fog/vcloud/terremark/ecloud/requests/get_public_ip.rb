module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_public_ip
        end

        module Mock
          #
          #Based off of:
          #http://support.theenterprisecloud.com/kb/default.asp?id=567&Lang=1&SID=
          #

          def get_public_ip(public_ip_uri)
            public_ip_uri = ensure_unparsed(public_ip_uri)
            if ip = mock_data[:organizations].map { |org| org[:vdcs] }.flatten.map { |vdc| vdc[:public_ips] }.flatten.detect { |ip| ip[:href] == public_ip_uri }
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.PublicIp(:xmlns => "urn:tmrk:eCloudExtensions-2.0", :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                  xml.Id(ip[:id])
                  xml.Href(ip[:href])
                  xml.Name(ip[:name])
                }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.publicIp+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end

        end
      end
    end
  end
end
