module Fog
  module Parsers
    module AWS
      module CloudFormation

        class DescribeStackResources < Fog::Parsers::Base

          def reset
            @resource = {}
            @response = { 'Resources' => [] }
          end

          def end_element(name)
            case name
            when 'StackId', 'StackName', 'LogicalResourceId', 'PhysicalResourceId', 'ResourceType', 'TimeStamp', 'ResourceStatus'
              @resource[name] = @value
            when 'member'
              @response['Resources'] << @resource
              @resource = {}
            end
          end

        end
      end
    end
  end
end
