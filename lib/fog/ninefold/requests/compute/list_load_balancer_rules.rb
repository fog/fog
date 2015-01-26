module Fog
  module Compute
    class Ninefold
      class Real
        def list_load_balancer_rules(options={})
          request 'listLoadBalancerRules', options, :expects => [200], :response_prefix => 'listloadbalancerrulesresponse', :response_type => Hash
        end
      end
    end
  end
end
