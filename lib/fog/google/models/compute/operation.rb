require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Operation < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :zone_name, :aliases => 'zone'
        attribute :status, :aliases => 'status'
        attribute :self_link, :aliases => 'selfLink'

        def ready?
          self.status == DONE_STATE
        end

        def pending?
          self.status == PENDING_STATE
        end

        def reload
          requires :identity

          data = collection.get(identity, zone)
          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        PENDING_STATE = "PENDING"
        RUNNING_STATE = "RUNNING"
        DONE_STATE = "DONE"

      end
    end
  end
end
