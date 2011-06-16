module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats(options = {})
          request(
            :path     => "/monitoring/load/stats",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end