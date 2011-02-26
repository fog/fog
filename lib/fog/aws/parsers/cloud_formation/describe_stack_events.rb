module Fog
  module Parsers
    module AWS
      module CloudFormation

        class DescribeStackEvents < Fog::Parsers::Base

          def reset
            @event = {}
            @response = { 'Events' => [] }
          end

          def end_element(name)
            case name
            when 'EventId', 'StackId', 'StackName', 'LogicalResourceId', 'PhysicalResourceId', 'ResourceType', 'Timestamp', 'ResourceStatus', 'ResourceStatusReason'
              @event[name] = @value
            when 'member'
              @response['Events'] << @event
              @event = {}
            end
          end

        end
      end
    end
  end
end
