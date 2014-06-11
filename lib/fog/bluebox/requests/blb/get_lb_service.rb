module Fog
  module Bluebox
    class BLB
      class Real
        # Get details of a lb_service.
        #
        # ==== Parameters
        # * lb_application_id<~String> - ID of application the service belongs to
        # * lb_service_id<~String> - ID of service to look up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> - service name
        #     * port<~Integer> - port of load balanced service
        #     * private<~Boolean> - whether service is only available internally
        #     * status_username<~String> - HTTP basic auth username
        #     * status_password<~String> - HTTP basic auth password
        #     * status_url<~String> - URL of stats page
        #     * service_type<~String> - proto being load balanced (e.g. 'http', 'tcp')
        #     * created<~DateTime> - when service was created
        def get_lb_service(lb_application_id, lb_service_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_applications/#{lb_application_id}/lb_services/#{lb_service_id}.json",
          )
        end
      end

      class Mock
      end
    end
  end
end
