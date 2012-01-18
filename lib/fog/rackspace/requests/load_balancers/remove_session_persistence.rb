module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def remove_session_persistence(load_balancer_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/sessionpersistence",
            :method => 'DELETE'
          )
         end
      end
    end
  end
end
