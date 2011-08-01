module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def delete_node(load_balancer_id, node_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}",
            :method => 'DELETE'
          )
        end
      end
      class Mock
        def delete_node(load_balancer_id, node_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
