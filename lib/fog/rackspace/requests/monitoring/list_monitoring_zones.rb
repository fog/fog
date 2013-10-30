module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_monitoring_zones
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "monitoring_zones"
          )
        end
      end
    end
  end
end
