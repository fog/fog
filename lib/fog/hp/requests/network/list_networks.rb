module Fog
  module HP
    class Network

      class Real

        # List existing networks
        #
        # ==== Parameters
        # * options<~Hash>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * networks<~Array>:
        #       * 'id'<~String>: - UUId for the network
        #       * 'name'<~String>: - Name of the network
        #       * 'tenant_id'<~String>: - TenantId that owns the network
        #       * 'status'<~String>: - Status of the network i.e. "ACTIVE"
        #       * 'subnets'<~Array>: - Subnets for the network
        #         * 'id'<~Integer>: - UUId for the subnet
        #       * 'router:external'<~Boolean>: - true or false
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'shared'<~Boolean>: - true or false
        def list_networks(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'networks',
            :query   => options
          )
        end
      end

      class Mock
        def list_networks(options = {})
          response = Excon::Response.new

          networks = self.data[:networks].values
          response.status = 200
          response.body = { 'networks' => networks }
          response
        end
      end

    end
  end
end