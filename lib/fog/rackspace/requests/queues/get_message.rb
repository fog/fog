module Fog
  module Rackspace
    class Queues
      class Real
        # This operation gets the specified message from the specified queue.
        #
        # @param [String] client_id UUID for the client instance.
        # @param [String] queue_name Specifies the name of the queue.
        # @param [Integer] message_id Specifies the message ID.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see  http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_getSpecificMessage__version__queues__queue_name__messages__messageId__message-operations-dle001.html
        def get_message(client_id, queue_name, message_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/messages/#{message_id}",
            :headers => { 'Client-ID' => client_id }
          )
        end
      end

      class Mock
        def get_message(client_id, queue_name, message_id)
          queue = mock_queue!(queue_name)

          message = queue.messages.find { |msg| msg.id == message_id }
          raise NotFound.new unless message

          response = Excon::Response.new
          response.status = 200
          response.body = message.to_h
          response
        end
      end
    end
  end
end
