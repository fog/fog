module Fog
  module Rackspace
    class Monitoring
      class Real

        def delete_alarm(entity_id, alarm_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}/alarms/#{alarm_id}"
          )
        end

      end
    end
  end
end

