module Fog
  module Orchestration
    class Rackspace
      class Real

        # List stacks.
        #
        # @param options [Hash]
        #
        # @return [Excon::Response]
        #   * body [Hash]:
        #     * stacks [Array] - Matching stacks
        #       * stack [Hash]:
        #         * id [String] -
        #         * stack_name [String] -
        #         * description [String]
        #         * links [Array]
        #         * stack_status [String] -
        #         * stack_status_reason [String]
        #         * creation_time [Time] -
        #         * updated_time [Time] -
        #
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_list_v1__tenant_id__stacks_Stack_Operations.html
        def list_stacks(options = {})
          request(
            :expects  => 200,
            :path => 'stacks',
            :method => 'GET',
            :query => options
          )
        end

      end

      class Mock
        def list_stacks(options = {})
          stacks = self.data[:stacks].values

          Excon::Response.new(
            :body   => { 'stacks' => stacks },
            :status => 200
          )
        end
      end
    end
  end
end
