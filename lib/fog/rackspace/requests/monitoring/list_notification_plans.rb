module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_notification_plans
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "notification_plans"
          )
        end

      end
    end
  end
end

