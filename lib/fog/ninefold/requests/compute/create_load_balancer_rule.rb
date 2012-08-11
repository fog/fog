module Fog
  module Compute
    class Ninefold
      class Real
        def create_load_balancer_rule(options={})
          request 'createLoadBalancerRule', options, :expects => [200], :response_prefix => 'createloadbalancerruleresponse', :response_type => Hash
        end
      end
    end
  end
end
