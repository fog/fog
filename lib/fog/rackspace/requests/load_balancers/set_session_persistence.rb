module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_session_persistence(load_balancer_id, persistence_type)
          data = {
            'sessionPersistence' => {
              'persistenceType' => persistence_type
            }
          }
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :path     => "loadbalancers/#{load_balancer_id}/sessionpersistence",
            :method   => 'PUT'
          )
         end
      end
    end
  end
end
