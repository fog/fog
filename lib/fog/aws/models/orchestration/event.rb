require 'fog/orchestration/models/event'

module Fog
  module Orchestration
    class AWS
      class Event < Fog::Orchestration::Event

        attribute :id, :aliases => ['EventId']
        attribute :event_time, :aliases => ['Timestamp']
        attribute :logical_resource_id, :aliases => ['LogicalResourceId']
        attribute :physical_resource_id, :aliases => ['PhysicalResourceId']
        attribute :resource_status, :aliases => ['ResourceStatus']
        attribute :resource_status_reason, :aliases => ['ResourceStatusReason']

        alias_method :resource_name, :logical_resource_id
        alias_method :resource_name=, :logical_resource_id=

      end
    end
  end
end
