module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real

          def get_public_ip(public_ip_uri)
            opts = {
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::GetPublicIp.new,
              :uri      => public_ip_uri
            }
            if self.class == Fog::Terremark::Ecloud::Real
              opts[:path] = "extensions/publicIp/#{public_ip_id}"
            end
            request(opts)
          end

        end

        module Mock
          #
          #Based off of:
          #http://support.theenterprisecloud.com/kb/default.asp?id=567&Lang=1&SID=
          #

          def get_public_ip(public_ip_uri)
            ip_id = public_ip_uri.to_s.split('/')[-1]
            if ip = mock_data[:organizations].map { |org| org[:vdcs] }.flatten.map { |vdc| vdc[:public_ips] }.flatten.detect { |ip| ip[:id].to_s == ip_id }
              xml = Builder::XmlMarkup.new
              mock_it(Fog::Parsers::Vcloud::Terremark::Ecloud::GetPublicIp.new, 200,
                xml.PublicIp(:xmlns => "urn:tmrk:eCloudExtensions-2.0", :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                  xml.Id(ip[:id])
                  xml.Href("#{Fog::Vcloud::Terremark::Ecloud::Mock.base_url}/extensions/publicIp/#{ip[:id]}")
                  xml.Name(ip[:name])
                }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.publicIp+xml' }
              )
            else
              mock_error 200, "401 Unauthorized"
            end
          end

        end
      end
    end
  end
end
