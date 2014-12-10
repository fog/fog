module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_ssl_termination(load_balancer_id)
          request(
            :expects => [200],
            :path => "loadbalancers/#{load_balancer_id}/ssltermination",
            :method => 'GET'
          )
         end
      end
    end
  end
end
