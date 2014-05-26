module Fog
  module Compute
    class Google
      class Mock
        def get_region_operation(region_name, operation)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def get_region_operation(region_name, operation)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.region_operations.get
          parameters = {
            'project' => @project,
            'region' => region_name,
            'operation' => operation
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
