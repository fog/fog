module Fog
  module Compute
    class HP
      class Real
        # List private server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        # * network_name<~String> - The name of the network name i.e. public, private or custom name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'private'<~Array> - Private ip addresses
        def list_server_private_addresses(server_id, network_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/#{network_name}.json"
          )
          # return the first address
          private_address = []
          data = response.body["#{network_name}"][0]
          if data
            private_address << data
          end

          response.body = { 'private' => private_address }
          response
        end
      end

      class Mock
        def list_server_private_addresses(server_id, network_name)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            private_address = []
            data = nil
            data = server['addresses']["#{network_name}"][0] if server['addresses']["#{network_name}"]
            if data
              private_address << data
            end

            response.status = 200
            response.body = { 'private' => private_address }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
