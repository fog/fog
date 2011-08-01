module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def get_node(load_balancer_id, node_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}.json",
            :method => 'GET'
          )
         end
      end
      class Mock
        def get_node(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
