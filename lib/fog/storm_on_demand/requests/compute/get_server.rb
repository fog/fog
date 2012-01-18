module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_server(options = {})
          request(
            :path     => "/storm/server/details",
            :body     => MultiJson.encode({:params => options})
          )
        end

      end
    end
  end
end