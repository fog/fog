module Fog
  module Terremark
    module Shared
      module Real

        # Get details for a Network
        #
        # ==== Parameters
        # * network_id<~Integer> - Id of the network to look up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'PublicIpAddresses'<~Array>
        #       * 'href'<~String> - linke to item
        #       * 'name'<~String> - name of item
        def get_network(network_id)
         request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Terremark::Shared::Network.new,
            :path     => "network/#{network_id}"
          )
        end

      end

      module Mock

        def get_network(network_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
