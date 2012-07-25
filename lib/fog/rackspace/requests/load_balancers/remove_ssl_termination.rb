module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def remove_ssl_termination(load_balancer_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/ssltermination",
            :method => 'DELETE'
          )
         end
      end
    end
  end
end
