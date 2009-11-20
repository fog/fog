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
        def list_private_addresses(server_id)
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

        def list_private_addresses(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].detect { |server| server['id'] == server_id }
            response.status = [200, 203][rand(1)]
            response.body = { 'private' => server['addresses']['private'] }
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 202}, response))
          end
          response
        end

      end
    end
  end

end
