module Fog
  module Compute
    class Google
      class Mock
        def delete_target_pool(target_pool_name, region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def delete_target_pool(target_pool_name, region_name)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.target_pools.delete
          parameters = {
            'project' => @project,
            'targetPool' => target_pool_name,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
