module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def list_load_balancers
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'loadbalancers.json'
          )
        end
      end
    end
  end
end
