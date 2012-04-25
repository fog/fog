module Fog
  module Compute
    class StormOnDemand
      class Real

        def resize_server(options = {})
          request(
            :path     => "/storm/server/resize",
            :body     => MultiJson.dump({:params => options})
          )
        end

      end
    end
  end
end