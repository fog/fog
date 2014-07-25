require 'fog/orchestration/models/resource'

module Fog
  module Orchestration
    class AWS
      # Resource for stack
      class Resource < Fog::Orchestration::Resource

        attribute :logical_resource_id, :aliases => ['LogicalResourceId']
        attribute :physical_resource_id, :aliases => ['PhysicalResourceId']
        attribute :resource_type, :aliases => ['ResourceType']
        attribute :updated_time, :aliases => ['LastUpdatedTimestamp']
        attribute :resource_status, :aliases => ['ResourceStatus']

        # resource name is the same as logical resource ID
        alias_method :logical_resource_id, :resource_name
        alias_method :logical_resource_id=, :resource_name=

      end
    end
  end
end
