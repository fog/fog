module Fog
  module Compute
    class Google
      class Mock
        def set_global_forwarding_rule_target(rule, target)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_global_forwarding_rule_target(rule, target)
          api_method = @compute.global_forwarding_rules.set_target
          parameters = {
            'project' => @project,
            'forwardingRule' => rule.name,
            'region' => 'global'
          }
          body = {
            'target' => target
          }

          request(api_method, parameters, body_object=body)
        end
      end
    end
  end
end
