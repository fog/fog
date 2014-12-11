module Fog
  module Rackspace
    class Queues
      class Real
        # This operation claims a set of messages (up to the value of the limit parameter) from oldest to newest and skips any messages that are already claimed.
        # If no unclaimed messages are available, the API returns a 204 No Content message.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @param [Integer] ttl The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        # @param [Integer] grace The grace attribute specifies the message grace period in seconds. The value of grace value must be between 60 and 43200 seconds (12 hours).
        # @param [Hash] options
        # @option options [Integer] :limit - Specifies the number of messages to return, up to 20 messages. If limit is not specified, limit defaults to 10.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_claimMessages__version__queues__queue_name__claims_claims-operations-dle001.html
        def create_claim(queue_name, ttl, grace, options = {})
          body = {
            :ttl => ttl,
            :grace => grace
          }

          query = {}
          query[:limit] = options[:limit] if options.key? :limit
          request(
            :body => Fog::JSON.encode(body),
            :expects => [200, 201, 204],
            :method => 'POST',
            :path => "queues/#{queue_name}/claims",
            :query => query
          )
        end
      end

      class Mock
        def create_claim(queue_name, ttl, grace, options = {})
          queue = mock_queue!(queue_name)

          limit = options[:limit] || 10

          claim = queue.add_claim(ttl, grace)

          claimed = queue.messages.select do |message|
            ! message.claimed?
          end.first(limit)

          if claimed.empty?
            response = Excon::Response.new
            response.status = 204
            return response
          end

          claimed.each do |message|
            message.claim = claim

            # Extend the message's lifetime to include the lifetime of the claim, plus the claim's
            # grace period.
            message.extend_life
          end

          response = Excon::Response.new
          response.status = 201
          response.body = claimed.map { |msg| msg.to_h }
          response.headers['Location'] = "#{PATH_BASE}/#{queue_name}/claims/#{claim.id}"
          response
        end
      end
    end
  end
end
