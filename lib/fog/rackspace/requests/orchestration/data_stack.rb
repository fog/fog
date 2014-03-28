module Fog
  module Orchestration
    class Rackspace
      class Real

        # Get stack data.
        #
        # * stack_name [String] Name of the stack to create.
        # * stack_id   [String] The unique identifer for a stack
        # @see http://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_ListStacks.html

        def data_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock
        def data_stack(stack_name, stack_id)
        end
      end
    end
  end
end
