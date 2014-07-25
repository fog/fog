require 'fog/orchestration/models/events'
require 'fog/aws/models/orchestration/event'
require 'fog/aws/models/orchestration/common'

module Fog
  module Orchestration
    class AWS
      # Events for stack
      class Events < Fog::Orchestration::Events

        include Fog::Orchestration::AWS::Common

        # Register stack event class
        model Fog::Orchestration::AWS::Event

        # Load all events for stack
        #
        # @param load_stack [Fog::Orchestration::AWS::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            unless(self.stack.attributes['Events'])
              self.stack.attributes['Events'] = fetch_paged_results('StackEvents') do |opts|
                service.describe_stack_events(self.stack.stack_name, opts)
              end
            end
            items = self.stack.attributes['Events']
          else
            items = []
          end
          load(items)
        end

      end
    end
  end
end
