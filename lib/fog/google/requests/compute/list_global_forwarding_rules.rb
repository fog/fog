module Fog
  module Compute
    class Google
      class Mock
        def list_global_forwarding_rules(region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_global_forwarding_rules(region_name)
          api_method = @compute.global_forwarding_rules.list
          parameters = {
            'project' => @project,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
