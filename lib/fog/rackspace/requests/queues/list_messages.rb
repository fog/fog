module Fog
  module Rackspace
    class Queues
      class Real
        # This operation gets the message or messages in the specified queue.
        #
        # A request to list messages when the queue is not found or when messages are not found returns 204, instead of 200, because there was no information to send back.
        # Messages with malformed IDs or messages that are not found by ID are ignored.
        #
        # @param [String] client_id UUID for the client instance.
        # @param [String] queue_name Specifies the name of the queue.
        # @param [Hash] options
        # @option options [String] :marker - Specifies an opaque string that the client can use to request the next batch of messages. The marker parameter communicates to the
        #   server which messages the client has already received. If you do not specify a value, the API returns all messages at the head of the queue (up to the limit).
        # @option options [Integer] :limit - When more messages are available than can be returned in a single request, the client can pick up the next batch of messages
        #   by simply using the URI template parameters returned from the previous call in the "next" field. Specifies up to 10 messages (the default value) to return.
        #   If you do not specify a value for the limit parameter, the default value of 10 is used.
        # @option options [String] :echo - Determines whether the API returns a client's own messages. The echo parameter is a Boolean value (true or false) that determines
        #   whether the API returns a client's own messages, as determined by the uuid portion of the User-Agent header. If you do not specify a value, echo uses the default
        #   value of false. If you are experimenting with the API, you might want to set echo=true in order to see the messages that you posted.
        # @option options [String] :include_claimed - Determines whether the API returns claimed messages and unclaimed messages. The include_claimed parameter is a Boolean
        #   value (true or false) that determines whether the API returns claimed messages and unclaimed messages. If you do not specify a value, include_claimed uses the
        #   default value of false (only unclaimed messages are returned).
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_getMessages__version__queues__queue_name__messages_message-operations-dle001.html
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

      class Mock
        def list_messages(client_id, queue_name, options = {})
          queue = mock_queue!(queue_name)

          marker = (options[:marker] || "0").to_i
          limit = options[:limit] || 10
          echo = options[:echo] || false
          include_claimed = options[:include_claimed] || false

          next_marker = marker + limit + 1
          messages = queue.messages[marker...next_marker]
          messages.reject! { |m| m.producer_id == client_id } unless echo
          messages.reject! { |m| m.claimed? } unless include_claimed

          response = Excon::Response.new
          if queue.messages.empty?
            response.status = 204
          else
            response.status = 200
            response.body = {
              "messages" => messages.map { |m| m.to_h },
              "links" => [{
                "href" => "#{PATH_BASE}/#{queue_name}/messages?marker=#{next_marker}",
                "rel" => "next"
              }]
            }
          end
          response
        end
      end
    end
  end
end
