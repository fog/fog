module Fog
  module Bluebox
    class BLB
      class Real

        # Get list of backends
        #
        # ==== Parameters
        # * lb_service_id - service containing backends
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'ip-v4'<~Array> - Ip addresses
        #     * 'ip-v6'<~String> - IP v6 address
        #     * 'name'<~String> - The hostname
        #     * 'source-ip-v4'<~String> - Where traffic comes from
        #     * 'services'<~Array> - Listening services
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
