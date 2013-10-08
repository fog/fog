module Fog
  module Rackspace
    class Queues
      class Real
        def get_queue(queue_name)
          request(
            :expects => [200, 204],
            :method => 'GET',
            :path => "queues/#{queue_name}"
          )
        end
      end
    end
  end
end
