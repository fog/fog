module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return resources for a stack
        #
        # * stack_name [String] Name of the stack to create.
        # * stack_id   [String] The unique identifer for a stack
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_resource_list_v1__tenant_id__stacks__stack_name___stack_id__resources_Stack_Resources.html

        def list_resources_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'resources'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock
        def list_resources_stack(stack_name, stack_id)
        end
      end
    end
  end
end
