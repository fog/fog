module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_images(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'images',
          )
        end

      end

      class Mock

        def list_images
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
