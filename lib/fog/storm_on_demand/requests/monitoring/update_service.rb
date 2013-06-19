module Fog
  module Monitoring
    class StormOnDemand
      class Real

        def update_service(options={})
          request(
            :path => '/Monitoring/Services/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
