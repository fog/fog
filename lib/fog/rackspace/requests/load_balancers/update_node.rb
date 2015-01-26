module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def update_node(load_balancer_id, node_id, options = {})
          data = {
            'node' => {}
          }
          if options.key? :weight
            data['node']['weight'] = options[:weight]
          end
          if options.key? :condition
            data['node']['condition'] = options[:condition]
          end
          if options.key? :type
            data['node']['type'] = options[:type]
          end
          #TODO - Do anything if no valid options are passed in?
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}.json"
          )
        end
      end
    end
  end
end
