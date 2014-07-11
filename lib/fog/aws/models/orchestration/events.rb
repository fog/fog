require 'fog/orchestration/models/events'
require 'fog/aws/models/orchestration/event'

module Fog
  module Orchestration
    class AWS
      class Events < Fog::Orchestration::Events

        model Fog::Orchestration::AWS::Event

        attr_accessor :stack

        def all(stack=nil)
          self.stack = stack if stack
          if(self.stack)
            unless(self.stack.attributes['Events'])
              self.stack.attributes['Events'] = service.describe_stack_events(
                self.stack.stack_name
              ).body['StackEvents']
            end
            load(self.stack.attributes['Events'])
          end
        end

      end
    end
  end
end
