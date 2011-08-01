module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def get_load_balancer(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}.json",
            :method => 'GET'
          )
         end
      end
      class Mock
        def get_load_balancer(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
