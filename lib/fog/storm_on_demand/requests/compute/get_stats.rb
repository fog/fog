module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats(options = {})
          request(
            :path     => "/monitoring/load/stats",
            :body     => MultiJson.encode({:params => options})
          )
        end

      end
    end
  end
end