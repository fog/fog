module Fog
  module HP
    class Network
      class Real
        # Get details for an existing router by id
        #
        # ==== Parameters
        # * 'router_id'<~String>: - UUId for the router to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * router<~Array>:
        #       * 'id'<~String>: - UUId for the router
        #       * 'name'<~String>: - Name of the router
        #       * 'tenant_id'<~String>: - TenantId that owns the router
        #       * 'status'<~String>: - Status of the router i.e. ACTIVE
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'external_gateway_info'<~Hash>: - External gateway info.
        #         * 'network_id'<~String>: - UUId of the external network
        def get_router(router_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "routers/#{router_id}"
          )
        end
      end

      class Mock
        def get_router(router_id)
          response = Excon::Response.new
          if router = list_routers.body['routers'].find {|_| _['id'] == router_id}
            response.status = 200
            response.body = { 'router' => router }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
