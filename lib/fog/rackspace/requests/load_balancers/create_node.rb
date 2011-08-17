module Fog
  module Rackspace
    class LoadBalancers
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
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "loadbalancers/#{load_balancer_id}/nodes.json"
          )
        end
      end
    end
  end
end
