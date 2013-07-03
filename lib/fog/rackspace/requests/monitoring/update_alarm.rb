module Fog
  module Rackspace
    class Monitoring
      class Real

        def update_alarm(entity_id, id, options)
          request(
            :body     => JSON.encode(options),
            :expects  => [204],
            :method   => 'PUT',
            :path     => "entities/#{entity_id}/alarms/#{id}"
          )
        end
      end
    end
  end
end

