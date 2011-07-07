module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def create_load_balancer(options = {})
          data = {
            'loadBalancer' => {
              'name' => options[:name],
              'port' => options[:port],
              'protocol' => options[:protocol],
              'virtualIps' => options[:virtualIps],
              'nodes' => options[:nodes]
            }
          }
          request(
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => 'loadbalancers.json'
          )
        end
      end
      class Mock
        def create_load_balancer(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
