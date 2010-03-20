module Fog
  module Rackspace
    module Servers
      class Real

        # List all server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'addresses'<~Array>:
        #     * 'public'<~Array> - Public ip addresses
        #     * 'private'<~Array> - Private ip addresses
        def list_addresses(server_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips.json"
          )
        end

      end

      class Mock

        def list_addresses(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].detect { |server| server['id'] == server_id }
            response.status = [200, 203][rand(1)]
            response.body = { 'addresses' => server['addresses'] }
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
