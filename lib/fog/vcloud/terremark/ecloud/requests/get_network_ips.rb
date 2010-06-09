module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def get_network_ips(network_ips_uri)
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::NetworkIps.new,
              :uri      => network_ips_uri
            )
          end

        end

        module Mock
          require 'ipaddr'

          def get_network_ips(network_ips_uri)
            response = Excon::Response.new
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:href] == network_ips_uri.to_s.gsub(%r:/ips$:,'') }
              xml = Builder::XmlMarkup.new
              mock_it Fog::Parsers::Vcloud::Terremark::Ecloud::NetworkIps.new, 200,
                xml.IpAddresses {
                  IPAddr.new(network[:name]).to_range.to_a[3..-2].each do |ip|
                    xml.IpAddress {
                      xml.Name(ip.to_s)
                      if network[:ips].has_key?(ip.to_s)
                        xml.Status("Assigned")
                        xml.Server(network[:ips][ip.to_s])
                      else
                        xml.Status("Available")
                      end
                    }
                  end
                },
                { 'Content-Type' => 'application/vnd.tmrk.ecloud.ipAddressesList+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
            

          end

        end
      end
    end
  end
end
