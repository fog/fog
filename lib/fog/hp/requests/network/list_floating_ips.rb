module Fog
  module HP
    class Network
      class Real
        # List existing floating ips
        #
        # ==== Parameters
        # * options<~Hash>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * floatingips<~Array>:
        #       * 'id'<~String>: - UUId for the floating ip
        #       * 'tenant_id'<~String>: - TenantId that owns the floating ip
        #       * 'floating_network_id'<~String>: - UUId of the external network
        #       * 'router_id'<~String>: - Id of the router, null if not assigned
        #       * 'fixed_ip_address'<~String>: - Fixed IP address associated to the floating IP, null if not assigned
        #       * 'floating_ip_address'<~String>: - Floating IP address
        #       * 'port_id'<~String>: - Port associated to the floating IP, null if not assigned

        def list_floating_ips(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'floatingips',
            :query   => options
          )
        end
      end

      class Mock
        def list_floating_ips(options = {})
          response = Excon::Response.new

          floatingips = self.data[:floating_ips].values
          response.status = 200
          response.body = { 'floatingips' => floatingips }
          response
        end
      end
    end
  end
end
