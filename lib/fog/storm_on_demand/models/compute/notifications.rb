require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/notification'

module Fog
  module Compute
    class StormOnDemand
      class Notifications < Fog::Collection
        model Fog::Compute::StormOnDemand::Notification

        def all(options={})
          data = service.list_notifications(options).body['items']
          load(data)
        end

        def current(options={})
          data = service.current_notifications(options).body['items']
          load(data)
        end

        def get(options)
          data = service.get_notification(options).body
          new(data)
        end
      end
    end
  end
end
