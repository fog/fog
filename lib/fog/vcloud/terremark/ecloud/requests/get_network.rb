module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          # Handled by the main Vcloud get_network
        end

        class Mock

          def get_network(network_uri)
            #
            # Based off of:
            # http://support.theenterprisecloud.com/kb/default.asp?id=546&Lang=1&SID=
            #
            network_uri = ensure_unparsed(network_uri)
            type = "application/vnd.vmware.vcloud.network+xml"
            response = Excon::Response.new
            if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:href] == network_uri }
              xml = Builder::XmlMarkup.new
              mock_it 200,
                xml.Network(xmlns.merge(:href => network[:href], :name => network[:name], :type => type)) {
                  xml.Link( :rel => "down", :href => network[:href] + "/ips", :type => "application/xml", :name => "IP Addresses" )
                  xml.Link( :rel => "down", :href => network[:extension_href], :type => "application/xml", :name => network[:name] )
                  xml.Configuration {
                    xml.Gateway(network[:gateway])
                    xml.Netmask(network[:netmask])
                  }
                  if network[:features]
                    xml.Features {
                      network[:features].each do |feature|
                        eval "xml.#{feature[:type].to_sym}('#{feature[:value]}')"
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

