module Fog
  module Rackspace
    class Queues
      class Real
        # This operation queries the specified claim for the specified queue. Claims with malformed IDs or claims that are not found by ID are ignored.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @param [Integer] claim_id Specifies the claim ID.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_queryClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
        def get_claim(queue_name, claim_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end

      class Mock
        def get_claim(queue_name, claim_id)
          queue = mock_queue!(queue_name)
          claim = queue.claim!(claim_id)

          response = Excon::Response.new
          response.status = 200
          response.body = claim.to_h
          response
        end
      end
    end
  end
end
