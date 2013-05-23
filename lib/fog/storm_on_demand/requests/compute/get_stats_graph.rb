module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_stats_graph(options={})
          request(
            :path => '/Monitoring/Load/graph',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
