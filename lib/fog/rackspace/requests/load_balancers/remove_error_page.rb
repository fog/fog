module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def remove_error_page(load_balancer_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/errorpage",
            :method => 'DELETE'
          )
         end
      end
    end
  end
end
