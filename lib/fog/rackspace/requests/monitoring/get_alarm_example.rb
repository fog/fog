module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_alarm_example(id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "alarm_examples/#{id}"
          )
        end
      end
    end
  end
end
