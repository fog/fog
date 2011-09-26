module Fog
  module Compute
    class OpenStack
      class Real

        def get_image_details(image_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "images/#{image_id}.json"
          )
        end

      end
    end
  end
end
