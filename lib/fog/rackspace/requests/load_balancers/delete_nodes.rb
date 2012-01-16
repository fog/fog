module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_nodes(load_balancer_id, *node_ids)
          query_string = node_ids.collect { |node_id| "id=#{node_id}" }.join('&')
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/nodes?#{query_string}",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
