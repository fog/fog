module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_regions(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'regions',
          )
        end

      end

      class Mock

        def list_regions
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
