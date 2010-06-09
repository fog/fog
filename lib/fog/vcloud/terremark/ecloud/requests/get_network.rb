module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def get_network(network_uri)
           request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::Network.new,
              :uri      => network_uri
            )
          end

        end

        module Mock

          def get_network(network_uri)
            #
            # Based off of:
            # http://support.theenterprisecloud.com/kb/default.asp?id=546&Lang=1&SID=
            #
            type = "application/vnd.vmware.vcloud.network+xml"
            response = Excon::Response.new
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:href] == network_uri.to_s }
              xml = Builder::XmlMarkup.new
              mock_it Fog::Parsers::Vcloud::Terremark::Ecloud::Network.new, 200,
                xml.Network(xmlns.merge(:href => network[:href], :name => network[:name], :type => type)) {
                  xml.Link( :rel => "down", :href => network[:href] + "/ips", :type => "application/xml", :name => "IP Addresses" )
                  xml.Configuration {
                    xml.Gateway(network[:gateway])
                    xml.Netmask(network[:netmask])
                  }
                  if network[:features]
                    xml.Features {
                      if feature = network[:features].detect { |feature| feature[:type] == :fencemode }
                        xml.FenceMode(feature[:value])
                      end
                    }
                  end
                },
                { 'Content-Type' => type }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end

