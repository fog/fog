module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_images
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'images'
          )
        end
      end
    end
  end
end
