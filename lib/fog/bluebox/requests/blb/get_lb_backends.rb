module Fog
  module Bluebox
    class BLB
      class Real
        # Get list of backends
        #
        # ==== Parameters
        # * lb_service_id<~String> - service containing backends
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * backend<~Hash>:
        #       * id<~String> - backend ID
        #       * backend_name<~String>
        #       * lb_machines<~Array> - array of backend members
        #       * acl_name<~String> - name of ACL for this backend
        #       * acl_rule<~String>
        #       * monitoring_url_hostname<~String> - HTTP host header for health check
        #       * monitoring_url<~String> - URL for health check
        #       * check_interval<~Integer> - time between checks, in milliseconds
        def get_lb_backends(lb_service_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_services/#{lb_service_id}/lb_backends.json"
          )
        end
      end

      class Mock
      end
    end
  end
end
