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
              'algorithm' => options[:algorithm],
              'timeout' => options[:timeout],
              'httpsRedirect' => options[:https_redirect]
            }
          }
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'PUT',
            :path     => "loadbalancers/#{load_balancer_id}.json"
          )
        end
      end
    end
  end
end
