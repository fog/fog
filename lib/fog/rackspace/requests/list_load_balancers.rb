module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def list_load_balancers
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'loadbalancers.json'
          )
        end
      end
      class Mock
        def list_load_balancers
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
