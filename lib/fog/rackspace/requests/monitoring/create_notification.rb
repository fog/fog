module Fog
  module Rackspace
    class Monitoring
      class Real
        def create_notification(options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'notifications'
          )
        end
      end
    end
  end
end
