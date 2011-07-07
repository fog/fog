module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def delete_load_balancer(load_balancer_id)
          request(
            :expects => 202,
            :path => "loadbalancers/#{load_balancer_id}",
            :method => 'DELETE'
          )
        end
      end
      class Mock
        def delete_load_balancer(load_balancer_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
