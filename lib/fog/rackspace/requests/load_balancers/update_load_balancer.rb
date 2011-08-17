module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def update_load_balancer(load_balancer_id, options = {})
          data = {
            'loadBalancer' => {
              'name' => options[:name],
              'port' => options[:port],
              'protocol' => options[:protocol],
              'algorithm' => options[:algorithm]
            }
          }
          request(
            :body     => MultiJson.encode(data),
            :expects  => 202,
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}.json"
          )
        end
      end
    end
  end
end
