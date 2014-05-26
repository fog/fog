module Fog
  module Rackspace
    class Queues
      class Real
        # This operation posts the specified message or messages.
        # @note You can submit up to 10 messages in a single request.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @param [Integer] ttl The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/PATCH_updateClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
        def update_claim(queue_name, claim_id, ttl)
          body = {
            :ttl => ttl
          }
          request(
            :body => Fog::JSON.encode(body),
            :expects => 204,
            :method => 'PATCH',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end

      class Mock
        def update_claim(queue_name, claim_id, ttl)
          queue = mock_queue!(queue_name)
          claim = queue.claim!(claim_id)

          claim.touch!
          claim.ttl = ttl

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
