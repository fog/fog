module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def list_algorithms
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'loadbalancers/algorithms'
          )
        end
      end
    end
  end
end
