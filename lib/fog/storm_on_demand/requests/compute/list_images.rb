module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_images(options = {})
          request(
            :path     => "/server/image/list",
            :body     => MultiJson.dump(options)
          )
        end

      end
    end
  end
end