module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_data_points(entity_id, check_id, metric_name, options)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}/metrics/#{metric_name}/plot",
            :query    => options
          )
        end

      end
    end
  end
end
