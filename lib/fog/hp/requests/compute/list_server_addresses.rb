module Fog
  module Compute
    class HP
      class Real
        # List all server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'addresses'<~Hash>:
        #     *  'novanet_7':<~Array>  - The network name can change based on setup
        def list_server_addresses(server_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips.json"
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
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
