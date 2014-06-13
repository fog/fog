require 'fog/orchestration/models/resources'
require 'fog/aws/models/orchestration/resource'

module Fog
  module Orchestration
    class AWS
      class Resources < Fog::Orchestration::Resources

        model Fog::Orchestration::AWS::Resource

        attribute :stack_name

        def all(stack=nil)
          self.stack_name = stack.stack_name if stack
          if(stack_name)
            load(
              service.describe_stack_resources(
                'StackName' => stack_name
              ).body['StackResources']
            )
          end
        end

      end
    end
  end
end
