module Fog
  module Compute
    class StormOnDemand
      class Real

        def current_notifications(options={})
          request(
            :path => '/Notifications/current',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
