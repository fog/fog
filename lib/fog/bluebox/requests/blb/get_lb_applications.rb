module Fog
  module Bluebox
    class BLB
      class Real

        # Get list of blocks
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'ip-v4'<~Array> - Ip addresses
        #     * 'ip-v6'<~String> - IP v6 address
        #     * 'name'<~String> - The hostname
        #     * 'source-ip-v4'<~String> - Where traffic comes from
        #     * 'services'<~Array> - Listening services
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
