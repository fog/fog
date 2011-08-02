module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def create_access_rule(load_balancer_id, address, type)
          #TODO - This can actually support adding multiple access rules.
          data = {
            'accessList' => [
              {
                'address' => address,
                'type' => type
              }
          ]}
          request(
            :body     => data.to_json,
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "loadbalancers/#{load_balancer_id}/accesslist"
          )
        end
      end
    end
  end
end
