module Fog
  module Compute
    class Ninefold
      class Real
        def assign_to_load_balancer_rule(options={})
          request 'assignToLoadBalancerRule', options, :expects => [200], :response_prefix => 'assigntoloadbalancerruleresponse', :response_type => Hash
        end
      end
    end
  end
end
