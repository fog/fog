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
    end
  end
end
