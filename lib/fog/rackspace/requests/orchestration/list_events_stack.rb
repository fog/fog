module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return resource events for a stack
        #
        # * stack_name [String] Name of the stack to create.
        # * stack_id   [String] The unique identifer for a stack
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_event_list_v1__tenant_id__stacks__stack_name___stack_id__events_Stack_Events.html

        def list_events_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'events'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock
        def list_events_stack(stack_name, stack_id)
        end
      end
    end
  end
end