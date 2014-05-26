module Fog
  module Compute
    class Ninefold
      class Real
        def remove_from_load_balancer_rule(options={})
          request 'removeFromLoadBalancerRule', options, :expects => [200], :response_prefix => 'removefromloadbalancerruleresponse', :response_type => Hash
        end
      end
    end
  end
end
