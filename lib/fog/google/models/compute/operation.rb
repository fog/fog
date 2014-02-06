require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Operation < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :id, :aliases => 'id'
        attribute :operation_type, :aliases => 'operationType'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :zone_name, :aliases => 'zone'
        attribute :status, :aliases => 'status'
        attribute :status_message, :aliases => 'statusMessage'
        attribute :self_link, :aliases => 'selfLink'
        attribute :target_link, :aliases => 'targetLink'
        attribute :error, :aliases => 'error'
        attribute :progress, :aliases => 'progress'

        def ready?
          requires :status
          self.status == DONE_STATE
        end

        def pending?
          requires :status
          self.status == PENDING_STATE
        end

        def failed?
          !self.error.nil?
        end

        def reload
          requires :identity

          data = collection.get(name, zone_name)

          new_attributes = data.attributes

          self.merge_attributes(new_attributes)
          self
        end

        PENDING_STATE = 'PENDING'
        RUNNING_STATE = 'RUNNING'
        DONE_STATE    = 'DONE'

      end
    end
  end
end
