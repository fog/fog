module Fog
  module Rackspace
    class LoadBalancer
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
            :body     => data.to_json,
            :expects  => [200, 202],
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}.json"
          )
        end
      end
      class Mock
        def update_node(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
