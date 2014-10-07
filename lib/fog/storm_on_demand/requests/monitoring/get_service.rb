module Fog
  module Monitoring
    class StormOnDemand
      class Real
        def get_service(options={})
          request(
            :path => '/Monitoring/Services/get',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
