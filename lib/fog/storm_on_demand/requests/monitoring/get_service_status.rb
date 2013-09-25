module Fog
  module Monitoring
    class StormOnDemand
      class Real

        def get_service_status(options={})
          request(
            :path => '/Monitoring/Services/status',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
