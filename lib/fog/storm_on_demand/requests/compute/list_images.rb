module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_images(options = {})
          request(
            :path     => "/server/image/list",
            :body     => Fog::JSON.encode(options)
          )
        end

      end
    end
  end
end