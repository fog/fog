require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Queue < Fog::Model
        # @!attribute [rw] name
        # @return [String] name of queue
        identity :name

        # Returns list of messages in the queue
        #
        # @return [Fog::Rackspace::Queues::Messages] Retrieves a collection of messages.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_getMessages__version__queues__queue_name__messages_message-operations-dle001.html
        def messages
          @messages ||= begin
            Fog::Rackspace::Queues::Messages.new({
              :service => service,
              :queue => self,
              :client_id => service.client_id,
              :echo => true
            })
          end
        end

        # Returns queue statistics, including how many messages are in the queue, categorized by status.
        #
        # @return [Hash] Retrieves a collection of messages.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_getQueueStats__version__queues__queue_name__stats_queue-operations-dle001.html
        def stats
          service.get_queue_stats(name).body['messages']
        end

        # Returns list of claims
        # @note The Rackspace Cloud does not currently provide a way to retrieve claims as such this list is maintained by fog. Claims are added to the claim collection
        # as they are created.
        # @return [Fog::Rackspace::Queues::Claims] Retrieves a collection of claims.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        def claims
          @claims ||= begin
            Fog::Rackspace::Queues::Claims.new({
              :service => service,
              :queue => self
            })
          end
        end

        # Helper method to enqueue a single message
        #
        # @param [String, Hash, Array] body The body attribute specifies an arbitrary document that constitutes the body of the message being sent. The size of this body is limited to 256 KB, excluding whitespace. The document must be valid JSON.
        # @param [Integer] ttl The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        # @param [Hash] options
        # @return [Boolean] returns true if message has been succesfully enqueued
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_postMessage__version__queues__queue_name__messages_message-operations-dle001.html
        def enqueue(body, ttl, options = {})
          messages.create(options.merge({:body => body, :ttl => ttl}))
        end

        # Helper method to claim (dequeue) a single message, yield the message, and then destroy it
        #
        # @param [Integer] ttl The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        # @param [Integer] grace The grace attribute specifies the message grace period in seconds. The value of grace value must be between 60 and 43200 seconds (12 hours).
        # @param [Hash] options
        # @yieldparam message claimed [Fog::Rackspace::Queues::Message]
        # @return [Boolean] Returns true if claim was successfully made
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        def dequeue(ttl, grace, options = {}, &block)
          claim = claims.create(
            options.merge(
            {
              :limit => 1,
              :ttl => ttl,
              :grace => grace
            }))

          if claim
            message = claim.messages.first
            yield message if block_given?
            message.destroy
            true
          else
            false
          end
        end

        # Creates queue
        # Requires name attribute to be populated
        #
        # @return [Boolean] returns true if queue has been succesfully saved
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_postMessage__version__queues__queue_name__messages_message-operations-dle001.html
        def save
          requires :name
          data = service.create_queue(name)
          true
        end

        # Destroys queue
        #
        # @return [Boolean] returns true if queue is deleted
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteQueue__version__queues__queue_name__queue-operations-dle001.html
        def destroy
          requires :name
          service.delete_queue(name)
          true
        end
      end
    end
  end
end
