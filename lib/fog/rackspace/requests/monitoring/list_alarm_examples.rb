module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_alarm_examples
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'alarm_examples'
          )
        end
      end
    end
  end
end
