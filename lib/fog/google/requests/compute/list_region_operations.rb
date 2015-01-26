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

          request(api_method, parameters)
        end
      end
    end
  end
end
