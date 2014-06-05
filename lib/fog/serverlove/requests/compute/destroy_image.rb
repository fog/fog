module Fog
  module Compute
    class Serverlove
      class Real
        def destroy_image(drive_id)
          request(:method => "post", :path => "/drives/#{drive_id}/destroy", :expects => 204)
        end
      end
    end
  end
end
