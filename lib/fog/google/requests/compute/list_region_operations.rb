module Fog
  module Compute
    class Google
      class Mock
        def list_region_operations(region)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def list_region_operations(region)
          api_method = @compute.region_operations.list
          parameters = {
            'region' => region,
            'project' => @project,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
