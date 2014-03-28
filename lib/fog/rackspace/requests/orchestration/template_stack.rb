module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return template for stack
        #
        # * stack_name [String] Name of the stack to create.
        # * stack_id   [String] The unique identifer for a stack
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_template_v1__tenant_id__stacks__stack_name___stack_id__template_Templates.html
        def template_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'template'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock
        def template(stack_name, stack_id)
        end
      end
    end
  end
end
