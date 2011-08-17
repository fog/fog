module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def update_node(load_balancer_id, node_id, options = {})
          data = {
            'node' => {}
          }
          if options.has_key? :weight
            data['node']['weight'] = options[:weight]
          end
          if options.has_key? :condition
            data['node']['condition'] = options[:condition]
          end
          #TODO - Do anything if no valid options are passed in?
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}.json"
          )
        end
      end
    end
  end
end
