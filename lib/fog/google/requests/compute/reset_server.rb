module Fog
  module Compute
    class Google

      module Shared
        # common methods for real and mocked requests 
      end

      class Mock
        include Shared

        def reset_server(server_name, zone_name)
          Fog::Mock.not_implemented
        end

      end

      class Real
        include Shared

        def reset_server(server_name, zone_name)
          zone_name  = find_zone(zone_name)
          api_method = @compute.instances.reset
          parameters = {
            'project'  => @project,
            'zone'     => zone_name,
            'instance' => server_name
          }

          result   = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
