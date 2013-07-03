module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_alarm(entity_id, alarm_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/alarms/#{alarm_id}"
          )
        end

      end
    end
  end
end


