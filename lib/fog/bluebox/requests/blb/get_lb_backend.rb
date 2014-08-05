module Fog
  module Bluebox
    class BLB
      class Real
        # Get details of an lb_backend.
        #
        # ==== Parameters
        # * lb_service_id<~String> - service backend belongs to
        # * lb_backend_id<~String> - backend to look up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * id<~String> - backend ID
        #     * backend_name<~String>
        #     * lb_machines<~Array> - array of backend members
        #     * acl_name<~String> - name of ACL for this backend
        #     * acl_rule<~String>
        #     * monitoring_url_hostname<~String> - HTTP host header for health check
        #     * monitoring_url<~String> - URL for health check
        #     * check_interval<~Integer> - time between checks, in milliseconds
        def get_lb_backend(lb_service_id, lb_backend_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_services/#{lb_service_id}/lb_backends/#{lb_backend_id}.json"
          )
        end
      end

      class Mock
      end
    end
  end
end
