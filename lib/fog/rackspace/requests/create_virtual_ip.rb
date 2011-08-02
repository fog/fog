module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def create_virtual_ip(load_balancer_id, type)
          data = {
            'type' => type,
            'ipVersion' => 'IPV6'
          }
          request(
            :body     => data.to_json,
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "loadbalancers/#{load_balancer_id}/virtualips.json"
          )
        end
      end
      class Mock
        def create_virtual_ip(load_balancer_id, type)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
