module Fog
  module Compute
    class Google
      class Mock
        def get_global_forwarding_rule(global_forwarding_rule_name, region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_global_forwarding_rule(global_forwarding_rule_name, region_name)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.global_forwarding_rules.get
          parameters = {
            'project' => @project,
            'forwardingRule' => global_forwarding_rule_name,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
