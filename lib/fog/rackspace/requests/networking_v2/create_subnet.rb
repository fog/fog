module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def create_subnet(subnet)
          data = {:subnet => subnet.attributes}

          request(
            :method  => 'POST',
            :body    => Fog::JSON.encode(data),
            :path    => "subnets",
            :expects => 201
          )
        end
      end
    end
  end
end
