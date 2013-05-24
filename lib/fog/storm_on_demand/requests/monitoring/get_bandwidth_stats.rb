module Fog
  module Monitoring
    class StormOnDemand
      class Real

        def get_bandwidth_stats(options={})
          request(
            :path => '/Monitoring/Bandwidth/stats',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
