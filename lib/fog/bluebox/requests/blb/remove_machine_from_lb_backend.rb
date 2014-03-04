module Fog
  module Bluebox
    class BLB
      class Real
        # remove machine from single backend
        #
        # === Parameters
        # * lb_backend_id<~String> - ID of backend
        # * lb_machine_id<~String> - ID of machine
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - success or failure message
        def remove_machine_from_lb_backend(lb_backend_id, lb_machine_id)
          request(
            :expects => 200,
            :method  => 'DELETE',
            :path    => "/api/lb_backends/#{lb_backend_id}/lb_machines/#{lb_machine_id}",
            :headers => {"Accept" => "text/plain"},
          )
        end
      end

      class Mock
      end
    end
  end
end
