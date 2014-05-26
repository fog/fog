module Fog
  module Compute
    class HPV2
      class Real
        # List all server addresses
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'addresses'<~Hash>:
        #     *  'custom':<~Array>  - IP addresses for the server. The network name can change based on setup.
        def list_server_addresses(server_id)
          request(
            :expects  => [200,203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips"
          )
        end
      end

      class Mock
        def list_server_addresses(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = 200
            response.body = { 'addresses' => server['addresses'] }
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
