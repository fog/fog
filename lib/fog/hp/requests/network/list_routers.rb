module Fog
  module HP
    class Network
      class Real
        # List existing routers
        #
        # ==== Parameters
        # * options<~Hash>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * routers<~Array>:
        #       * 'id'<~String>: - UUId for the router
        #       * 'name'<~String>: - Name of the router
        #       * 'tenant_id'<~String>: - TenantId that owns the router
        #       * 'status'<~String>: - Status of the router i.e. ACTIVE
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'external_gateway_info'<~Hash>: - External gateway info.
        #         * 'network_id'<~String>: - UUId of the external network
        def list_routers(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'routers',
            :query   => options
          )
        end
      end

      class Mock
        def list_routers(options = {})
          response = Excon::Response.new

          routers = self.data[:routers].values
          response.status = 200
          response.body = { 'routers' => routers }
          response
        end
      end
    end
  end
end
