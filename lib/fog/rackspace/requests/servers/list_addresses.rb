unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #   * 'addresses'<~Array>:
        #     * 'public'<~Array> - Public ip addresses
        #     * 'private'<~Array> - Private ip addresses
        def list_addresses
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_addresses
        end

      end
    end
  end

end
