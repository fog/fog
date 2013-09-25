module Fog
  module Compute
    class Google

      class Mock

        def list_zone_operations
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_zone_operations(zone)
          api_method = @compute.zone_operations.list
          parameters = {
            'zone' => zone,
            'project' => @project,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
