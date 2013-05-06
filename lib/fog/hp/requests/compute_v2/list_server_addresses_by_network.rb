module Fog
  module Compute
    class HPV2
      class Real

        # List private server addresses
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to list addresses for
        # * 'network_id'<~String> - UUId of the network to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'custom'<~Array> - IP addresses for the server, for the network. The network name can change based on setup.
        def list_server_addresses_by_network(server_id, network_id)
          request(
            :expects  => [200,203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/#{network_id}"
          )
        end

      end

      class Mock

        def list_server_addresses_by_network(server_id, network_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].detect {|_| _['id'] == server_id}
            response.status = 200
            # since we cannot get to networks from compute, just return all addresses
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
