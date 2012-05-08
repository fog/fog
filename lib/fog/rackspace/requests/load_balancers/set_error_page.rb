module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_error_page(load_balancer_id, content)
          data = {
            'errorpage' => {
              'content' => content
            }
          }
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/errorpage",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
