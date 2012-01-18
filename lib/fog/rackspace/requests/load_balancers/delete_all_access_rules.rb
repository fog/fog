module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_all_access_rules(load_balancer_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/accesslist",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
