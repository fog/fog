module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_content_caching(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/contentcaching",
            :method => 'GET'
          )
         end
      end
    end
  end
end
