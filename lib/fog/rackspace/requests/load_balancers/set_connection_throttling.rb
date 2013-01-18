module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_connection_throttling(load_balancer_id, max_connections, min_connections, max_connection_rate, rate_interval)
          data = {
            'maxConnections' => max_connections,
            'minConnections' => min_connections,
            'maxConnectionRate' => max_connection_rate,
            'rateInterval' => rate_interval
          }
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/connectionthrottle",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
