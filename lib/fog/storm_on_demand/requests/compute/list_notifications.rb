module Fog
  module Compute
    class StormOnDemand
      class Real
        def list_notifications(options={})
          request(
            :path => '/Notifications/all',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
