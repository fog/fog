#
# AFAICT - This is basically undocumented - 6/18/2010 - freeformz
#

module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_network_ips
        end

        module Mock
          require 'ipaddr'

          def get_network_ips(network_ips_uri)
            network_ips_uri = ensure_unparsed(network_ips_uri)
            response = Excon::Response.new
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:href] == network_ips_uri.gsub(%r:/ips$:,'') }
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.IpAddresses {
                  IPAddr.new(network[:name]).to_range.to_a[3..-2].each do |ip|
                    xml.IpAddress {
                      xml.Name(ip.to_s)
                      xml.Href("#{Fog::Vcloud::Terremark::Ecloud::Mock.extension_url}/ip/#{ip.to_s.gsub('.','')}")
                      if network[:ips].has_key?(ip.to_s)
                        xml.Status("Assigned")
                        xml.Server(network[:ips][ip.to_s])
                      else
                        xml.Status("Available")
                      end
                      xml.RnatAddress(network[:rnat])
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
