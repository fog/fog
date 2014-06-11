module Fog
  module Compute
    class Google
      class Mock
        def insert_forwarding_rule(forwarding_rule_name, region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_forwarding_rule(forwarding_rule_name, region_name, opts = {})
          api_method = @compute.forwarding_rules.insert
          parameters = {
            'project' => @project,
            'region' => region_name
          }
          body_object = { 'name' => forwarding_rule_name }
          body_object.merge!(opts)

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
