module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_virtual_ip(load_balancer_id, virtual_ip_id)
          request(
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/virtualips/#{virtual_ip_id}",
            :method => 'DELETE'
          )
        end
      end
    end
  end
end
