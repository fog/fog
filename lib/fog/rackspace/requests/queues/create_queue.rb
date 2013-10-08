module Fog
  module Rackspace
    class Queues
      class Real
        def create_queue(queue_name)
          request(
            :body => Fog::JSON.encode({}),
            :expects => 201,
            :method => 'PUT',
            :path => "queues/#{queue_name}"
          )
        end
      end
    end
  end
end
