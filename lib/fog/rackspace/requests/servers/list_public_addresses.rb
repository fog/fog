unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List public server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'public'<~Array> - Public ip addresses
        def list_public_addresses
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/public.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_public_addresses
        end

      end
    end
  end

end
