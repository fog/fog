module Fog
  module Orchestration
    class Rackspace
      class Real

        # Get stack data.
        #
        # @param stack_name [String] name of stack
        # @param stack_id [String] ID of stack
        #
        # @return [Excon::Response]
        #   * body [Hash]:
        #     * stack [Hash]:
        #       * disable_rollback [TrueClass, FalseClass]
        #       * description [String]
        #       * parameters [Hash]
        #       * stack_status_reason [String]
        #       * stack_name [String]
        #       * outputs [Array]
        #       * creation_time [String]
        #       * links [Hash]
        #       * capabilities [Array]
        #       * notification_topics [Array]
        #       * timeout_mins [Integer]
        #       * stack_status [String]
        #       * updated_time [String]
        #       * id [String]
        #       * template_description [String]
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_show_v1__tenant_id__stacks__stack_name___stack_id__Stack_Operations.html
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
