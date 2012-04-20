module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats(options = {})
          request(
            :path     => "/monitoring/load/stats",
            :body     => MultiJson.dump({:params => options})
          )
        end

      end
    end
  end
end