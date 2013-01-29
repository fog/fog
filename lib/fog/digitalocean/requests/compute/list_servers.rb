module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_servers(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets',
          )
        end

      end

      class Mock

        def list_servers
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
