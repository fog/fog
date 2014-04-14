module Fog
  module Compute
    class Google

      class Mock

        def add_target_pool_instances(target_pool, instances)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def add_target_pool_instances(target_pool, instances)
          api_method = @compute.target_pools.add_instance
          parameters = {
            'project' => @project,
            'targetPool' => target_pool.name,
            'region' => target_pool.region.split('/')[-1]
          }
          body = {
            'instances' => instances.collect { |i| { 'instance' => i } }
          }

          result = self.build_result(api_method, parameters, body_object=body)
          self.build_response(result)
        end

      end

    end
  end
end
