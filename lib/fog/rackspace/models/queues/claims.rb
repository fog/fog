require 'fog/core/collection'
require 'fog/rackspace/models/queues/claim'

module Fog
  module Rackspace
    class Queues
      class Claims < Fog::Collection

        model Fog::Rackspace::Queues::Claim

        attr_accessor :queue

        def all
          self
        end

        def create(attributes = {})
          object = new(attributes)
          if object.save
            object
          else
            false
          end
        end

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
