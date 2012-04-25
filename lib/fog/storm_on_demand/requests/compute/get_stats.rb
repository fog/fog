module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats(options = {})
          request(
            :path     => "/monitoring/load/stats",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end