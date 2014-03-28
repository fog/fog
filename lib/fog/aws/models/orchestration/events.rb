require 'fog/orchestration/models/events'
require 'fog/aws/models/orchestration/event'

module Fog
  module Orchestration
    class AWS
      class Events < Fog::Orchestration::Events

        model Fog::Orchestration::AWS::Event

        def all(stack)
          load(service.describe_stack_events(stack.stack_name).body['StackEvents'])
        end

      end
    end
  end
end
