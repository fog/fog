module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def create_node(load_balancer_id, address, port, condition, options = {})
          data = {
            'nodes' => [
              {
                'address' => address,
                'port' => port,
                'condition' => condition
              }
          ]}
          if options.has_key?(:weight)
            data['nodes'][0]['weight'] = options[:weight]
          end
          request(
            :body     => data.to_json,
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "loadbalancers/#{load_balancer_id}/nodes.json"
          )
        end
      end
      class Mock
        def create_node(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
