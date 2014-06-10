require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/notification'

module Fog
  module Rackspace
    class Monitoring
      class Notifications < Fog::Collection
        model Fog::Rackspace::Monitoring::Notification

        attribute :marker

        def all(options={})
          data = service.list_notifications(options).body
          marker = data['metadata']['next_marker']

          load(data['values'])
        end

        def get(notification_id)
          data = service.get_notification(notification_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end
      end
    end
  end
end
