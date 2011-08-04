module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def list_nodes(load_balancer_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "loadbalancers/#{load_balancer_id}/nodes.json"
          )
        end
      end
      class Mock
        def list_nodes(load_balancer_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
