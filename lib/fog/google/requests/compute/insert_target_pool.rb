module Fog
  module Compute
    class Google
      class Mock
        def insert_target_pool(name, region_name, opts = {})
          # check that region exists
          get_region(region_name)

          id = Fog::Mock.random_numbers(19).to_s
          self.data[:target_pools][name] = {
            "kind" => "compute#targetPools",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => name,
            "description" => '',
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "instances" => opts['instances'],
            "healthChecks" => opts['healthChecks'],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/targetPools/#{name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/targetPools/#{name}",
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
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
        def insert_target_pool(target_pool_name, region_name, opts = {})
          api_method = @compute.target_pools.insert
          parameters = {
            'project' => @project,
            'region' => region_name
          }
          body_object = { 'name' => target_pool_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
