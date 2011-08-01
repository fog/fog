module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def delete_virtual_ip(load_balancer_id, virtual_ip_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/virtualips/#{virtual_ip_id}",
            :method => 'DELETE'
          )
        end
      end
      class Mock
        def delete_virtual_ip(load_balancer_id, virtual_ip_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
