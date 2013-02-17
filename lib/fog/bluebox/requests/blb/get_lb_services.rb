module Fog
  module Bluebox
    class BLB
      class Real

        # Get list of load balancing services
        #
        # ==== Parameters
        # * lb_application_id<~String> - Id of application services to list
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        def get_lb_services(lb_application_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_applications/#{lb_application_id}/lb_services.json"
          )
        end

      end
      class Mock
      end
    end
  end
end
