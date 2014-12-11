module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def update_network(network)
          data = {:network => {:name => network.name}}

          request(
            :method  => 'PUT',
            :body    => Fog::JSON.encode(data),
            :path    => "networks/#{network.id}",
            :expects => 200
          )
        end
      end
    end
  end
end
