module Fog
  module Orchestration
    class OpenStack
      class Real

        # Delete a stack.
        #
        # @param stack_name [String] Name of the stack to delete.
        # @param stack_id [String] ID of the stack to delete.
        #
        # @return [Excon::Response]
        #
        # @see http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_DeleteStack.html

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
