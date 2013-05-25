module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_notification(options={})
          request(
            :path => '/Notifications/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
