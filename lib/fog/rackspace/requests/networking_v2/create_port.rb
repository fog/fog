module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def create_port(port)
          data = {:port => port.attributes}

          request(
            :method  => 'POST',
            :body    => Fog::JSON.encode(data),
            :path    => "ports",
            :expects => 201
          )
        end
      end
    end
  end
end
