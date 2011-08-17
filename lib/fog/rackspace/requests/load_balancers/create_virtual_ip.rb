module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def create_virtual_ip(load_balancer_id, type)
          data = {
            'type' => type,
            'ipVersion' => 'IPV6'
          }
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "loadbalancers/#{load_balancer_id}/virtualips.json"
          )
        end
      end
    end
  end
end
