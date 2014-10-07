module Fog
  module HP
    class Network
      class Real
        # Get details for an existing floating ip by id
        #
        # ==== Parameters
        # * 'floating_ip_id'<~String>: - UUId for the floating ip to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * floatingip<~Array>:
        #       * 'id'<~String>: - UUId for the floating ip
        #       * 'tenant_id'<~String>: - TenantId that owns the floating ip
        #       * 'floating_network_id'<~String>: - UUId of the external network
        #       * 'router_id'<~String>: - Id of the router, null if not assigned
        #       * 'fixed_ip_address'<~String>: - Fixed IP address associated to the floating IP, null if not assigned
        #       * 'floating_ip_address'<~String>: - Floating IP address
        #       * 'port_id'<~String>: - Port associated to the floating IP, null if not assigned
        def get_floating_ip(floating_ip_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "floatingips/#{floating_ip_id}"
          )
        end
      end

      class Mock
        def get_floating_ip(floating_ip_id)
          response = Excon::Response.new
          if floating_ip = list_floating_ips.body['floatingips'].find {|_| _['id'] == floating_ip_id}
            response.status = 200
            response.body = { 'floatingip' => floating_ip }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
