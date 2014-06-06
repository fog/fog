module Fog
  module Compute
    class HP
      class Real
        # List public server addresses
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list addresses for
        # * network_name<~String> - The name of the network name i.e. public, private or custom name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'public'<~Array> - Public ip addresses
        def list_server_public_addresses(server_id, network_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/#{network_name}.json"
          )
          # return everything except the first address
          data = response.body["#{network_name}"]
          if data
            data.delete_at(0)
            public_address = data
          end

          response.body = { 'public' => public_address }
          response
        end
      end

      class Mock
        def list_server_public_addresses(server_id, network_name)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            # return everything except the first address
            data = server['addresses']["#{network_name}"]
            if data
              data.delete_at(0)
              public_address = data
            end

            response.status = 200
            response.body = { 'public' => public_address }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
