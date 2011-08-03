module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def list_virtual_ips(load_balancer_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "loadbalancers/#{load_balancer_id}/virtualips.json"
          )
        end
      end
      class Mock
        def list_virtual_ips(load_balancer_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
