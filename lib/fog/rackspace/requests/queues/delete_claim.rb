module Fog
  module Rackspace
    class Queues
      class Real
        # This operation immediately releases a claim, making any remaining, undeleted) messages that are associated with the claim available to other workers.
        # Claims with malformed IDs or claims that are not found by ID are ignored.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @param [String] claim_id Specifies the claim ID.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
        def delete_claim(queue_name, claim_id)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end

      class Mock
        def delete_claim(queue_name, claim_id)
          queue = mock_queue!(queue_name)
          claim = queue.claim!(claim_id)

          claim.messages.each do |message|
            message.claim = nil
          end
          queue.claims.delete(claim_id)

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
