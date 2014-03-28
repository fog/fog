require 'fog/orchestration/models/resource'

module Fog
  module Orchestration
    class AWS
      class Resource < Fog::Orchestration::Resource


        attribute :logical_resource_id, :aliases => ['LogicalResourceId']
        attribute :physical_resource_id, :aliases => ['PhysicalResourceId']
        attribute :resource_type, :aliases => ['ResourceType']
        attribute :updated_time, :aliases => ['Timestamp']
        attribute :resource_status, :aliases => ['ResourceStatus']

        def initialize(*args)
          super
          self.resource_name = self.logical_resource_id
        end

      end
    end
  end
end
