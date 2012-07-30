module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_image(image_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "images/#{image_id}"
          )
        end
      end
    end
  end
end
