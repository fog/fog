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
              self.stack.attributes['Events'] = fetch_events
            end
            load(self.stack.attributes['Events'])
          end
        end

        def fetch_events(next_token=nil)
          stack_events = []
          options = next_token ? {'NextToken' => next_token} : {}
          result = service.describe_stack_events(
            self.stack.stack_name, options
          )
          stack_events += result.body['StackEvents']
          if(result.body['NextToken'])
            stack_events += fetch_events(result.body['NextToken'])
          end
          stack_events
        end

      end
    end
  end
end
