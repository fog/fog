module Fog
  module Orchestration
    class Rackspace
      class Real

        # Delete a stack.
        #
        # @param stack_name [String] Name of the stack to delete.
        # @param stack_id [String] ID of the stack to delete.
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/DELETE_stack_delete_v1__tenant_id__stacks__stack_name___stack_id__Stack_Operations.html
        def delete_stack(stack_name, stack_id)
          request(
            :expects  => 204,
            :path => "stacks/#{stack_name}/#{stack_id}",
            :method => 'DELETE'
          )
        end

      end

      class Mock
        def delete_stack(stack_name, stack_id)
          self.data[:stacks].delete(stack_id)

          response = Excon::Response.new
          response.status = 204
          response.body = {}
          response
        end
      end
    end
  end
end
