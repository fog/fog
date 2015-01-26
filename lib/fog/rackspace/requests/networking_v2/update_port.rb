module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def update_port(port)
          data = {:port => {:name => port.name}}

          request(
            :method  => 'PUT',
            :body    => Fog::JSON.encode(data),
            :path    => "ports/#{port.id}",
            :expects => 200
          )
        end
      end
    end
  end
end
