module Fog
  module Compute
    class Google
      class Mock
        def insert_global_forwarding_rule(global_forwarding_rule_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_global_forwarding_rule(global_forwarding_rule_name, opts = {})
          api_method = @compute.global_forwarding_rules.insert
          parameters = {
            'project' => @project,
          }
          body_object = { 'name' => global_forwarding_rule_name, 'region' => 'global' }
          body_object.merge!(opts)

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
