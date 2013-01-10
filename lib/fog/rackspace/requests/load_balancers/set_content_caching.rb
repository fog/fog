module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_content_caching(load_balancer_id, value)
          data = {
            'contentCaching' => {
              'enabled' => value.to_s
            }
          }
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/contentcaching",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
