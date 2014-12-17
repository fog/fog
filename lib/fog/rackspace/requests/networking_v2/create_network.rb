module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def create_network(network)
          data = {:network => network.attributes}

          request(
            :method  => 'POST',
            :body    => Fog::JSON.encode(data),
            :path    => "networks",
            :expects => 201
          )
        end
      end
    end
  end
end
