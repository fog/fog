module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def set_connection_logging(load_balancer_id, value)
          data = {
            'connectionLogging' => {
              'enabled' => value.to_s
            }
          }
          request(
            :body     => data.to_json,
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/connectionlogging",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
