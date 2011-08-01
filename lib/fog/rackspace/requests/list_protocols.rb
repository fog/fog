module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def list_protocols
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'loadbalancers/protocols'
          )
        end
      end
    end
  end
end
