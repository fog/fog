module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real

          def get_public_ips(public_ips_uri)
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::GetPublicIps.new,
              :uri      => public_ips_uri
            )
          end
        end

        module Mock

          #
          #Based off of:
          #http://support.theenterprisecloud.com/kb/default.asp?id=577&Lang=1&SID=
          #
          def get_public_ips(public_ips_uri)
            if vdc = mock_data[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| vdc[:href].split('/').last == public_ips_uri.to_s.split('/')[-2] }
              xml = Builder::XmlMarkup.new
              mock_it Fog::Parsers::Vcloud::Terremark::Ecloud::GetPublicIps.new, 200,
                xml.PublicIPAddresses {
                  vdc[:public_ips].each do |ip|
                    xml.PublicIPAddress {
                      xml.Id(ip[:id])
                      xml.Href("#{Fog::Vcloud::Terremark::Ecloud::Mock.base_url}/extensions/publicIp/#{ip[:id]}")
                      xml.Name(ip[:name])
                    }
                  end
                }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.publicIpsList+xml'}
            else
              mock_error 200, "401 Unauthorized"
            end
          end

        end
      end
    end
  end
end

