module Fog
  module Compute
    class Serverlove
      class Real
        def get_image(image_id)
          request(:method => "get", :path => "/drives/#{image_id}/info", :expects => 200)
        end
      end
    end
  end
end
