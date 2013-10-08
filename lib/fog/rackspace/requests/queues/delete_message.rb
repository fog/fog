module Fog
  module Rackspace
    class Queues
      class Real
        def delete_message(queue_name, message_id, options = {})
          query = {}
          query[:claim_id] = options[:claim_id] if options.has_key? :claim_id
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}/messages/#{message_id}",
            :query => query
          )
        end
      end
    end
  end
end
