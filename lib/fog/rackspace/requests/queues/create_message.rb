module Fog
  module Rackspace
    class Queues
      class Real
        def create_message(client_id, queue_name, body, ttl)
          data = [{
            :ttl => ttl,
            :body => body
          }]
          request(
            :body => Fog::JSON.encode(data),
            :expects => 201,
            :method => 'POST',
            :path => "queues/#{queue_name}/messages",
            :headers => { 'Client-ID' => client_id }
          )
        end
      end
    end
  end
end
