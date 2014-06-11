module Fog
  module Compute
    class Google
      class Mock
        def insert_target_pool(target_pool_name, region_name)
          Fog::Mock.not_implemented
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

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
