module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_node(load_balancer_id, node_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}.json",
            :method => 'GET'
          )
         end
      end
    end
  end
end
