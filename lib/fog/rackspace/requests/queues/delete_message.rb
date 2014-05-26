module Fog
  module Rackspace
    class Queues
      class Real
        # This operation immediately deletes the specified message.
        # @note If you do not specify claim_id, but the message is claimed, the operation fails. You can only delete claimed messages by providing an appropriate claim_id.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @param [String] message_id Specifies the message ID.
        # @param [Hash] options
        # @option options [Integer] :claim_id - Identifies the claim.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteMessage__version__queues__queue_name__messages__messageId__message-operations-dle001.html
        def delete_message(queue_name, message_id, options = {})
          query = {}
          query[:claim_id] = options[:claim_id] if options.key? :claim_id
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}/messages/#{message_id}",
            :query => query
          )
        end
      end

      class Mock
        def delete_message(queue_name, message_id, options = {})
          queue = mock_queue!(queue_name)

          claim_id = options[:claim_id]

          message = queue.messages.find { |m| m.id == message_id }

          perform_delete = true
          if message && message.claimed?
            unless message.claim.id == claim_id
              # Currently returns a 204 without deleting!
              perform_delete = false
            end
          else
            if claim_id
              # Currently returns a 204 without deleting!
              perform_delete = false
            end
          end

          if perform_delete
            queue.messages.reject! { |m| m.id == message_id }
          end

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
