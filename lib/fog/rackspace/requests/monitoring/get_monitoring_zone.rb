module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_monitoring_zone by_id
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "monitoring_zones/#{by_id}"
          )
        end
      end
    end
  end
end
