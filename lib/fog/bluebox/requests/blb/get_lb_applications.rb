module Fog
  module Bluebox
    class BLB
      class Real
        # Get list of applications
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'application'<~Hash>:
        #       * 'id'<~String> - UUID of application
        #       * 'ip_v4'<~Array> - IPv4 addresses
        #       * 'ip_v6'<~String> - IPv6 address
        #       * 'name'<~String> - The hostname
        #       * 'lb_services'<~Array> - Listening services
        #       * 'source_ip_v4'<~String> - address that application connects to pool members from (v1 only)
        def get_lb_applications
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'api/lb_applications.json'
          )
        end
      end

      class Mock
      end
    end
  end
end
