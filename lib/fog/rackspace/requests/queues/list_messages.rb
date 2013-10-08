module Fog
  module Rackspace
    class Queues
      class Real
        def list_messages(client_id, queue_name, options = {})
          request(
            :expects => [200, 204],
            :method => 'GET',
            :path => "queues/#{queue_name}/messages",
            :headers => { 'Client-ID' => client_id },
            :query => options
          )
        end
      end
    end
  end
end
