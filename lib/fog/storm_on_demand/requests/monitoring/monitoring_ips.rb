module Fog
  module Monitoring
    class StormOnDemand
      class Real

        def monitoring_ips(options={})
          request(
            :path => '/Monitoring/Services/monitoringIps',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
