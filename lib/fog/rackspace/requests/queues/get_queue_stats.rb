module Fog
  module Rackspace
    class Queues
      class Real
        def get_queue_stats(queue_name)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/stats"
          )
        end
      end
    end
  end
end
