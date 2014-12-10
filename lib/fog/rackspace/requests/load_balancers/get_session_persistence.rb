module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_session_persistence(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/sessionpersistence",
            :method => 'GET'
          )
         end
      end
    end
  end
end
