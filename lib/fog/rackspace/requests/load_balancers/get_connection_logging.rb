module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_connection_logging(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/connectionlogging",
            :method => 'GET'
          )
         end
      end
    end
  end
end
