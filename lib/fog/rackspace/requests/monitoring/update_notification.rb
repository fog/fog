module Fog
  module Rackspace
    class Monitoring
      class Real
        def update_notification(id, options)
          request(
            :body     => JSON.encode(options),
            :expects  => [204],
            :method   => 'PUT',
            :path     => "notifications/#{id}"
          )
        end
      end
    end
  end
end
