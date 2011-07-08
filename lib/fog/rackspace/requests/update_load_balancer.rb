module Fog
  module Rackspace
    class LoadBalancer
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
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}.json"
          )
        end
      end
      class Mock
        def update_load_balancer(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
