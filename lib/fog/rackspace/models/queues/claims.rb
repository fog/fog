require 'fog/core/collection'
require 'fog/rackspace/models/queues/claim'

module Fog
  module Rackspace
    class Queues
      class Claims < Fog::Collection
        model Fog::Rackspace::Queues::Claim

        # @!attribute [rw] queue
        # @return [String] The queue associated with the claim collection
        attr_accessor :queue

        # Returns list of claims
        # @note The Rackspace Cloud does not currently provide a way to retrieve claims as such this list is maintained by fog. Claims are added to the claim collection
        # as they are created.
        # @return [Fog::Rackspace::Queues::Claims] Retrieves a collection of claims.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        def all
          self
        end

        # This operation claims a set of messages (up to the value of the limit parameter) from oldest to newest and skips any messages that are already claimed.
        # @return [Fog::Rackspace::Queues::Claim] Returns a claim
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_claimMessages__version__queues__queue_name__claims_claims-operations-dle001.html
        def create(attributes = {})
          object = new(attributes)
          if object.save
            object
          else
            false
          end
        end

        # This operation queries the specified claim for the specified queue. Claims with malformed IDs or claims that are not found by ID are ignored.
        #
        # @param [Integer] claim_id Specifies the claim ID.
        # @return [Fog::Rackspace::Queues::Claim] Returns a claim
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_queryClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
        def get(claim_id)
          requires :queue
          data = service.get_claim(queue.identity, claim_id).body
          new(data)
        rescue Fog::Rackspace::Queues::NotFound
          nil
        # HACK - This has been escalated to the Rackspace Queues team, as this
        # behavior is not normal HTTP behavior.
        rescue Fog::Rackspace::Queues::ServiceError
          nil
        end
      end
    end
  end
end
