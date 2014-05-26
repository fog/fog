module Fog
  module Compute
    class Ninefold
      class Real
        def list_load_balancer_rule_instances(options={})
          request 'listLoadBalancerRuleInstances', options, :expects => [200], :response_prefix => 'listloadbalancerruleinstancesresponse', :response_type => Hash
        end
      end
    end
  end
end
