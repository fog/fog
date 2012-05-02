module Fog
  module Compute
    class Ecloudv2
      class Task < Fog::Model
        identity :href

        attribute :type , :aliases => :Type
        attribute :operation, :aliases => :Operation
        attribute :status, :aliases => :Status
        attribute :impacted_item, :aliases => :ImpactedItem
        attribute :start_time, :aliases => :StartTime
        attribute :completed_time, :aliases => :CompletedTime
        attribute :notes, :aliases => :Notes
        attribute :error_message, :aliases => :ErrorMessage
        attribute :InitiatedBy, :aliases => :InitiatedBy

      end
    end
  end
end
