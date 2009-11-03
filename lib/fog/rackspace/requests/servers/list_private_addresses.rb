unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List private server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'private'<~Array> - Public ip addresses
        def list_private_addresses
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/private.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_private_addresses
        end

      end
    end
  end

end
