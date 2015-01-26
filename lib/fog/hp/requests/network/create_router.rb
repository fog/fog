module Fog
  module HP
    class Network
      class Real
        # Create a new router
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the router
        #   * 'admin_state_up'<~Boolean> - The administrative state of the router, true or false
        #   * 'tenant_id'<~String> - TenantId different than the current user, that should own the network. Only allowed if user has 'admin' role.
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
        def create_router(options = {})
          data = { 'router' => {} }

          l_options = [:name, :admin_state_up, :tenant_id, :external_gateway_info]
          l_options.select{|o| options[o]}.each do |key|
            data['router'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 201,
            :method   => 'POST',
            :path     => 'routers'
          )
        end
      end

      class Mock
        def create_router(options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'id'                    => Fog::HP::Mock.uuid.to_s,
            'name'                  => options[:name] || "",
            'status'                => 'ACTIVE',
            'external_gateway_info' => options[:external_gateway_info] || nil,
            'admin_state_up'        => options[:admin_state_up] || true,
            'tenant_id'             => options[:tenant_id] || Fog::Mock.random_numbers(14).to_s
          }
          self.data[:routers][data['id']] = data
          response.body = { 'router' => data }
          response
        end
      end
    end
  end
end
