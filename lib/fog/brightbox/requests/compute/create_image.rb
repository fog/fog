module Fog
  module Compute
    class Brightbox
      class Real

        def create_image(options)
          request("post", "/1.0/images", [201], options)
        end

      end
    end
  end
end