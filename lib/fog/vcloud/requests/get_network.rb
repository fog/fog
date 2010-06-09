module Fog
  module Vcloud
    class Real

      def get_network(network_uri)
       request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Vcloud::Network.new,
          :uri      => uri
        )
      end

    end

    class Mock

      def get_network(network_uri)
        #
        # Based off of:
        # vCloud API Guide v0.8 - Page 50
        #
        # Did not implement AssociatedNetwork, seems redundant, haven't seen it in use yet
        # Did not implement the following features: Dhcp, Nat & Firewall
        #
        type = "application/vnd.vmware.vcloud.network+xml"
        response = Excon::Response.new
        if network = mock_data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:networks] } }.flatten.detect { |network| network[:href] == network_uri.to_s }
          xml = Builder::XmlMarkup.new
          mock_it Fog::Parsers::Vcloud::Network.new, 200,
            xml.Network(xmlns.merge(:href => network[:href], :name => network[:name], :type => type)) {
              xml.Description(network[:name])
              xml.Configuration {
                xml.Gateway(network[:gateway])
                xml.Netmask(network[:netmask])
                xml.Dns(network[:dns])
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
