module Fog
  module Compute
    class Google
      class Mock
        def remove_target_pool_health_checks(target_pool, health_checks)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def remove_target_pool_health_checks(target_pool, health_checks)
          api_method = @compute.target_pools.remove_health_check
          parameters = {
            'project' => @project,
            'targetPool' => target_pool.name,
            'region' => target_pool.region.split('/')[-1]
          }
          body = {
            'healthChecks' => health_checks.map { |i| { 'healthCheck' => i } }
          }

          result = self.build_result(api_method, parameters, body_object=body)
          self.build_response(result)
        end
      end
    end
  end
end
