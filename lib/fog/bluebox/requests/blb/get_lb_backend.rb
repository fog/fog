module Fog
  module Bluebox
    class BLB
      class Real

        # Get details of a lb_backend.
        #
        # ==== Parameters
        # * lb_service_id - service backend belongs to
        # * lb_backend_id<~Integer> - backend to look up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO
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
