require 'fog/orchestration/models/events'
require 'fog/rackspace/models/orchestration/event'

module Fog
  module Orchestration
    class Rackspace
      class Events < Fog::Orchestration::Events

        model Fog::Orchestration::Rackspace::Event

        def all(stack)
          load(service.list_events_stack(stack.stack_name, stack.id).body['events'])
        end

      end
    end
  end
end
