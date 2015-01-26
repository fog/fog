module Fog
  module Compute
    class HPV2
      class Real
        # List private server addresses
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to list addresses for
        # * 'network_name'<~String> - Name of the network to list addresses for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'custom'<~Array> - IP addresses for the server, for the network. The network name can change based on setup.
        #       * 'version'<~Integer> - IP version, 4 or 6
        #       * 'addr'<~String> - IP address
        def list_server_addresses_by_network(server_id, network_name)
          request(
            :expects  => [200,203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/#{Fog::HP.escape(network_name)}"
          )
        end
      end

      class Mock
        def list_server_addresses_by_network(server_id, network_name)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = 200
            # get the addresses for the network, which is 'custom' in case of mocks
            address = server['addresses'].select { |key, _| key == network_name}
            response.body = address
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
