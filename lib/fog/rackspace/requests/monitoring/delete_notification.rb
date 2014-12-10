module Fog
  module Rackspace
    class Monitoring
      class Real
        def delete_notification(notification_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "notifications/#{notification_id}"
          )
        end
      end
    end
  end
end
