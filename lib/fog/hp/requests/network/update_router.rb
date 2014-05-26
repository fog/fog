module Fog
  module HP
    class Network
      class Real
        # Update an existing router by id
        #
        # ==== Parameters
        # * 'router_id'<~String>: - UUId for the router
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the router
        #   * 'admin_state_up'<~Boolean> - The administrative state of the router, true or false
        #   * 'external_gateway_info'<~Hash>: - External gateway info.
        #     * 'network_id'<~String>: - UUId of the external network
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
        def update_router(router_id, options = {})
          data = { 'router' => {} }

          l_options = [:name, :admin_state_up, :external_gateway_info]
          l_options.select{|o| options[o]}.each do |key|
            data['router'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "routers/#{router_id}"
          )
        end
      end

      class Mock
        def update_router(router_id, options = {})
          response = Excon::Response.new
          if router = list_routers.body['routers'].find {|_| _['id'] == router_id}
            router['name']                  = options[:name]
            router['admin_state_up']        = options[:admin_state_up]
            router['external_gateway_info'] = options[:external_gateway_info]
            response.body = { 'router' => router }
            response.status = 200
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
