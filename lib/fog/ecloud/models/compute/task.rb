module Fog
  module Compute
    class Ecloud
      class Task < Fog::Ecloud::Model
        identity :href

        attribute :type , :aliases => :Type
        attribute :operation, :aliases => :Operation
        attribute :status, :aliases => :Status
        attribute :impacted_item, :aliases => :ImpactedItem
        attribute :start_time, :aliases => :StartTime
        attribute :completed_time, :aliases => :CompletedTime
        attribute :notes, :aliases => :Notes
        attribute :error_message, :aliases => :ErrorMessage
        attribute :initiated_by, :aliases => :InitiatedBy

        def ready?
          !self.completed_time.nil?
        end
      end
    end
  end
end
