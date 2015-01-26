module Fog
  module HP
    class Network
      class Real
        # Get details for an existing network by id
        #
        # ==== Parameters
        # * 'network_id'<~String>: - UUId for the network to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * network<~Hash>:
        #       * 'id'<~String>: - UUId for the network
        #       * 'name'<~String>: - Name of the network
        #       * 'tenant_id'<~String>: - TenantId that owns the network
        #       * 'status'<~String>: - Status of the network i.e. "ACTIVE"
        #       * 'subnets'<~Array>: - Subnets for the network
        #         * 'id'<~Integer>: - UUId for the subnet
        #       * 'router:external'<~Boolean>: - true or false
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'shared'<~Boolean>: - true or false
        def get_network(network_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "networks/#{network_id}"
          )
        end
      end

      class Mock
        def get_network(network_id)
          response = Excon::Response.new
          if network = list_networks.body['networks'].find {|_| _['id'] == network_id}
            response.status = 200
            response.body = { 'network' => network }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
