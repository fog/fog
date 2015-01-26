require 'fog/core/model'

module Fog
  module Compute
    class Google
      class Operation < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :client_operation_id, :aliases => 'clientOperationId'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :end_time, :aliases => 'endTime'
        attribute :error
        attribute :http_error_message, :aliases => 'httpErrorMessage'
        attribute :http_error_status_code, :aliases => 'httpErrorStatusCode'
        attribute :insert_time, :aliases => 'insertTime'
        attribute :operation_type, :aliases => 'operationType'
        attribute :progress
        attribute :region
        attribute :self_link, :aliases => 'selfLink'
        attribute :start_time, :aliases => 'startTime'
        attribute :status
        attribute :status_message, :aliases => 'statusMessage'
        attribute :target_id, :aliases => 'targetId'
        attribute :target_link, :aliases => 'targetLink'
        attribute :user
        attribute :warnings
        attribute :zone

        def ready?
          self.status == DONE_STATE
        end

        def pending?
          self.status == PENDING_STATE
        end

        def region_name
          region.nil? ? nil : region.split('/')[-1]
        end

        def zone_name
          zone.nil? ? nil : zone.split('/')[-1]
        end

        def destroy
          requires :identity

          if zone
            service.delete_zone_operation(zone, identity)
          elsif region
            service.delete_region_operation(region, identity)
          else
            service.delete_global_operation(identity)
          end
          true
        end

        def reload
          requires :identity

          data = collection.get(identity, zone, region)
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
