module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_access_rule(load_balancer_id, access_rule_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/accesslist/#{access_rule_id}",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
