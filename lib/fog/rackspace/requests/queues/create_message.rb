module Fog
  module Rackspace
    class Queues
      class Real

        # This operation posts the specified message or messages.
        # @note You can submit up to 10 messages in a single request.
        #
        # @param [String] client_id UUID for the client instance.
        # @param [String] queue_name Specifies the name of the queue.
        # @param [String, Hash, Array] body The body attribute specifies an arbitrary document that constitutes the body of the message being sent.
        #   The size of this body is limited to 256 KB, excluding whitespace. The document must be valid JSON.
        # @param [Integer] ttl The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_postMessage__version__queues__queue_name__messages_message-operations-dle001.html
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
