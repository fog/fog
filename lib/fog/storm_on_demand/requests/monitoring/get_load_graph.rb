module Fog
  module Monitoring
    class StormOnDemand
      class Real
        def get_load_graph(options={})
          request(
            :path => '/Monitoring/Load/graph',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
