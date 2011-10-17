module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_nodes(load_balancer_id, *node_ids)
          query_string = node_ids.collect { |node_id| "id=#{node_id}" }.join('&')
          puts query_string
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/nodes?#{node_ids}",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
