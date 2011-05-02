module Fog
  module StormOnDemand
    class Compute
      class Real

        def list_images(options = {})
          request(
            :path     => "/server/image/list",
            :body     => options.to_json
          )
        end

      end
    end
  end
end