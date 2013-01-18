module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_error_page(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/errorpage",
            :method => 'GET'
          )
         end
      end
    end
  end
end
