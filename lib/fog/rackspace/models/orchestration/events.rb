require 'fog/orchestration/models/events'
require 'fog/rackspace/models/orchestration/event'

module Fog
  module Orchestration
    class Rackspace
      # Events for stack
      class Events < Fog::Orchestration::Events

        # Regsiter stack event model
        model Fog::Orchestration::Rackspace::Event

        # Load all events for stack
        #
        # @param load_stack [Fog::Orchestration::Rackspace::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            unless(self.stack.attributes['events'])
              self.stack.attributes['events'] = service.
                list_events_stack(self.stack.stack_name, self.stack.id).
                body['events']
              self.stack.attributes['events'].sort! do |event_x, event_y|
                Time.parse(event_y['event_time']) <=> Time.parse(event_x['event_time'])
              end
            end
            items = self.stack.attributes['events']
          else
            items = []
          end
          load(items)
        end

      end
    end
  end
end
