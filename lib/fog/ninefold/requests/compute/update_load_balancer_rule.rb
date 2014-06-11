module Fog
  module Compute
    class Ninefold
      class Real
        def update_load_balancer_rule(options={})
          request 'updateLoadBalancerRule', options, :expects => [200], :response_prefix => 'updateloadbalancerruleresponse', :response_type => Hash
        end
      end
    end
  end
end
