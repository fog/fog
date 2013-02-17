module Fog
  module Bluebox
    class BLB
      class Real

        # Get details of a lb_application.
        #
        # ==== Parameters
        # * lb_application_id<~Integer> - Id of block to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO
        def get_lb_application(lb_application_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/lb_applications/#{lb_application_id}.json"
          )
        end

      end

      class Mock
      end
    end
  end
end
