module Fog
  module Compute
    class Ninefold
      class Real
        def delete_load_balancer_rule(options={})
          request 'deleteLoadBalancerRule', options, :expects => [200], :response_prefix => 'deleteloadbalancerruleresponse', :response_type => Hash
        end
      end
    end
  end
end
