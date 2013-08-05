module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_metrics(entity_id, check_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}/metrics"
          )
        end

      end
    end
  end
end

