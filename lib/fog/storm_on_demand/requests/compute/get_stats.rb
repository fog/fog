module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats(options = {})
          request(
            :path     => "/Monitoring/Load/stats",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end