module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_flavors(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'sizes'
          )
        end

      end

      class Mock

        def list_flavors
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
