require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Message < Fog::Model
        # @!attribute [r] age
        # @return [Integer] The number of seconds relative to the server's clock.
        attribute :age

        # @!attribute [rw] ttl
        # @return [Integer] specifies how long the server waits before marking the message as expired and removing it from the queue.
        # @note The value of ttl must be between 60 and 1209600 seconds (14 days). Note that the server might not actually delete the message until its
        # age has reached up to (ttl + 60) seconds, to allow for flexibility in storage implementations.
        attribute :ttl

        # @!attribute [rw] body
        # @return [String, Hash, Array] specifies an arbitrary document that constitutes the body of the message being sent. The size of this body is limited to 256 KB, excluding whitespace. The document must be valid JSON.
        attribute :body

        # @!attribute [r] href
        # @return [String] location of the message
        attribute :href

        # @!attribute [r] claim_id
        # @return [String] the id of the claim
        attribute :claim_id

        # @!attribute [r] identity
        # @return [String] The messages identity
        def identity
          return nil unless href

          match = href.match(/\A.*\/queues\/[a-zA-Z0-9_-]{0,64}\/messages\/(.+?)(?:\?|\z)/i)
          match ? match[1] : nil
        end
        alias_method :id, :identity

        # Creates messages
        # Requires queue, client_id, body, and ttl attributes to be populated
        # @note messages cannot be updated
        #
        # @return [Boolean] returns true if message has been succesfully saved
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_postMessage__version__queues__queue_name__messages_message-operations-dle001.html
        def save
          requires :queue, :client_id, :body, :ttl
          raise "Message has already been created and may not be updated." unless identity.nil?
          data = service.create_message(client_id, queue.name, body, ttl).body
          self.href = data['resources'][0]
          true
        end

        # Destroys Message
        #
        # @return [Boolean] returns true if message is deleted
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteMessage__version__queues__queue_name__messages__messageId__message-operations-dle001.html
        def destroy
          requires :identity, :queue
          options = {}
          options[:claim_id] = claim_id unless claim_id.nil?

          service.delete_message(queue.name, identity, options)
          true
        end

        private

        def queue
          collection.queue
        end

        def client_id
          collection.client_id
        end
      end
    end
  end
end
