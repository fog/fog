require 'fog/orchestration/models/resources'
require 'fog/aws/models/orchestration/resource'

module Fog
  module Orchestration
    class AWS
      class Resources < Fog::Orchestration::Resources

        model Fog::Orchestration::AWS::Resource

        attr_accessor :stack

        def all(stack=nil)
          self.stack = stack if stack
          if(self.stack)
            unless(self.stack.attributes['Resources'])
              self.stack.attributes['Resources'] = service.describe_stack_resources(
                'StackName' => self.stack.stack_name
              ).body['StackResources']
            end
            load(self.stack.attributes['Resources'])
          end
        end

      end
    end
  end
end
