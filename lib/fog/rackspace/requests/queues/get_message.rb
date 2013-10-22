module Fog
  module Rackspace
    class Queues
      class Real
        def get_message(client_id, queue_name, message_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/messages/#{message_id}",
            :headers => { 'Client-ID' => client_id }
          )
        end
      end
    end
  end
end
