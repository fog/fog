require 'fog/orchestration/models/resources'
require 'fog/aws/models/orchestration/resource'

module Fog
  module Orchestration
    class AWS
      class Resources < Fog::Orchestration::Resources

        model Fog::Orchestration::AWS::Resource

        def all(stack)
          load(
            service.describe_stack_resources(
              'StackName' => stack.stack_name
            ).body['StackResources']
          )
        end

      end
    end
  end
end
