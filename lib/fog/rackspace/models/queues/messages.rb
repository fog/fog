require 'fog/core/collection'
require 'fog/rackspace/models/queues/message'

module Fog
  module Rackspace
    class Queues
      class Messages < Fog::Collection
        model Fog::Rackspace::Queues::Message

        # @!attribute [r] client_id
        # @return [String] UUID for the client instance.
        attr_accessor :client_id

        # @!attribute [r] queue
        # @return [String] The name of the queue associated with the message.
        attr_accessor :queue

        # @!attribute [rw] echo
        # @return [Boolean] Determines whether the API returns a client's own messages. The echo parameter is a Boolean value (true or false) that determines whether the API
        #   returns a client's own messages, as determined by the uuid portion of the User-Agent header. If you do not specify a value, echo uses the default value of false.
        #   If you are experimenting with the API, you might want to set echo=true in order to see the messages that you posted.
        attr_accessor :echo

        # @!attribute [rw] limit
        # @return [String]  When more messages are available than can be returned in a single request, the client can pick up the next batch of messages by simply using the URI
        #   template parameters returned from the previous call in the "next" field. Specifies up to 10 messages (the default value) to return. If you do not specify a value
        #   for the limit parameter, the default value of 10 is used.
        attr_accessor :limit

        # @!attribute [rw] marker
        # @return [String] Specifies an opaque string that the client can use to request the next batch of messages. The marker parameter communicates to the server which
        #   messages the client has already received. If you do not specify a value, the API returns all messages at the head of the queue (up to the limit).
        attr_accessor :marker

        # @!attribute [rw] include_claimed
        # @return [String]  Determines whether the API returns claimed messages and unclaimed messages. The include_claimed parameter is a Boolean value (true or false)
        #   that determines whether the API returns claimed messages and unclaimed messages. If you do not specify a value, include_claimed uses the default value of false
        #   (only unclaimed messages are returned).
        attr_accessor :include_claimed

        # Returns list of messages
        #
        # @return [Fog::Rackspace::Queues::Messages] Retrieves a collection of messages.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        def all
          requires :client_id, :queue
          response = service.list_messages(client_id, queue.name, options)
          if response.status == 204
            data = []
          else
            data = response.body['messages']
          end
          load(data)
        end

        # Returns the specified message from the queue.
        #
        # @param [Integer] message_id id of the message to be retrieved
        # @return [Fog::Rackspace::Queues::Claim] Returns a claim
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        def get(message_id)
          requires :client_id, :queue
          data = service.get_message(client_id, queue.name, message_id).body
          new(data)
        rescue Fog::Rackspace::Queues::NotFound
          nil
        # HACK - This has been escalated to the Rackspace Queues team, as this
        # behavior is not normal HTTP behavior.
        rescue Fog::Rackspace::Queues::ServiceError
          nil
        end

        private

        def options
          data = {}
          data[:echo] = echo.to_s unless echo.nil?
          data[:limit] = limit.to_s unless limit.nil?
          data[:marker] = marker.to_s unless marker.nil?
          data[:include_claimed] = include_claimed.to_s unless include_claimed.nil?
          data
        end
      end
    end
  end
end
