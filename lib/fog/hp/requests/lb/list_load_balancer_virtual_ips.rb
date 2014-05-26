module Fog
  module HP
    class LB
      # List virtual IPs for an existing load balancer
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of the load balancer to get virtual IPs for
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'virtualIps'<~Array>:
      #       * 'id'<~String> - UUId for the virtual IP
      #       * 'address'<~String> - Address for the virtual IP
      #       * 'type'<~String> - Type for the virtual IP e.g. 'PUBLIC'
      #       * 'ipVersion'<~String> - Version for virtual IP e.g. 'IPV4', 'IPV6'
      class Real
        def list_load_balancer_virtual_ips(load_balancer_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/virtualips"
          )
        end
      end
      class Mock
        def list_load_balancer_virtual_ips(load_balancer_id)
          response = Excon::Response.new
          if lb_data = get_load_balancer(load_balancer_id)
            virtual_ips = lb_data.body['virtualIps']
            response.status = 200
            response.body   = { 'virtualIps' => virtual_ips }
            response
          else
            raise Fog::HP::LB::NotFound
          end
        end
      end
    end
  end
end
