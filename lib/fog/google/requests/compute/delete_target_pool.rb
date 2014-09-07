module Fog
  module Compute
    class Google
      class Mock
        def delete_target_pool(name, region_name)
          get_target_pool(name, region_name)
          id = Fog::Mock.random_numbers(19).to_s
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/targetPools/#{name}",
            "targetId" => id,
            "status" => "DONE",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/operations/#{operation}"
          }

          build_excon_response(self.data[:operations][operation])
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

          request(api_method, parameters)
        end
      end
    end
  end
end
