module Fog
  module Rackspace
    class Queues
      class Real
        def delete_queue(queue_name)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}"
          )
        end
      end
    end
  end
end
