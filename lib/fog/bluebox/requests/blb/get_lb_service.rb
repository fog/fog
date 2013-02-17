module Fog
  module Bluebox
    class BLB
      class Real

        # Get details of a lb_service.
        #
        # ==== Parameters
        # * lb_application_id<~String> - Id of application the service is in
        # * lb_service_id<~String> - Id of service to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO
        def get_lb_service(lb_application_id, lb_service_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_applications/#{lb_application_id}/lb_services/#{lb_service_id}.json"
          )
        end

      end

      class Mock
      end
    end
  end
end
