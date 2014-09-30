module Fog
  module Compute
    class Google
      class Mock
        def delete_region_operation(region, operation)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def delete_region_operation(region_name, operation)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end
          api_method = @compute.region_operations.delete
          parameters = {
            'project' => @project,
            'region' => region_name,
            'operation' => operation
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
