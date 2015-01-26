module Fog
  module Bluebox
    class BLB
      class Real
        # Get list of machines
        #
        # ==== Parameters
        # * lb_backend_id<~String> - backend containing machines
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * machine<~Hash>:
        #       * id<~String> - machine ID
        #       * ip<~String> - machine IP address for this member (v4 or v6)
        #       * port<~Integer> - service port for this member
        #       * hostname<~String> - name as registered with Box Panel
        #       * acl_name<~String> - name of ACL for this machine
        #       * created<~DateTime> - when machine was added to load balancer backend
        #       * maxconn<~Integer> - maximum concurrent connections for this member (BLBv2 only)
        def get_lb_machines(lb_backend_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_backends/#{lb_backend_id}/lb_machines.json"
          )
        end
      end

      class Mock
      end
    end
  end
end
