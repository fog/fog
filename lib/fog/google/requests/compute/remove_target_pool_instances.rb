module Fog
  module Compute
    class Google
      class Mock
        def remove_target_pool_instances(target_pool, instances)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def remove_target_pool_instances(target_pool, instances)
          api_method = @compute.target_pools.remove_instance
          parameters = {
            'project' => @project,
            'targetPool' => target_pool.name,
            'region' => target_pool.region.split('/')[-1]
          }
          body = {
            'instances' => instances.map { |i| { 'instance' => i } }
          }

          request(api_method, parameters, body_object=body)
        end
      end
    end
  end
end
