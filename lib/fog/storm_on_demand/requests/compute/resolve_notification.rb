module Fog
  module Compute
    class StormOnDemand
      class Real
        def resolve_notification(options={})
          request(
            :path => '/Notifications/resolve',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
