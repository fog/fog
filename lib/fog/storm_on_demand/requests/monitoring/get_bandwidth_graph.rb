module Fog
  module Monitoring
    class StormOnDemand
      class Real

        def get_bandwidth_graph(options={})
          request(
            :path => '/Monitoring/Bandwidth/graph',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
