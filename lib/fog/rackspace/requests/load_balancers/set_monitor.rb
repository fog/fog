module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_monitor(load_balancer_id, type, delay, timeout, attempsBeforeDeactivation, options = {})
          data = {
            'type' => type,
            'delay' => delay,
            'timeout' => timeout,
            'attemptsBeforeDeactivation' => attempsBeforeDeactivation
          }
          if options.key? :path
            data['path'] = options[:path]
          end
          if options.key? :body_regex
            data['bodyRegex'] = options[:body_regex]
          end
          if options.key? :status_regex
            data['statusRegex'] = options[:status_regex]
          end
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/healthmonitor",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
