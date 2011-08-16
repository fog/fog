module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_node(load_balancer_id, node_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
