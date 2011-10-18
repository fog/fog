module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_monitor(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/healthmonitor",
            :method => 'GET'
          )
         end
      end
    end
  end
end
