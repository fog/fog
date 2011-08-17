module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_load_balancer(load_balancer_id)
          request(
            :expects => 202,
            :path => "loadbalancers/#{load_balancer_id}.json",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
