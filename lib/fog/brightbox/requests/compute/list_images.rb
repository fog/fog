module Fog
  module Compute
    class Brightbox
      class Real

        def list_images
          request("get", "/1.0/images", [200])
        end

      end
    end
  end
end