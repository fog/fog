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
        #       * links [Array]
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
          stack = {
            'disable_rollback' => false,
            'description' => '',
            'parameters' => {},
            'stack_status_reason' => '',
            'stack_name' => '',
            'outputs' => [],
            'creation_time' => Time.now,
            'links' => [],
            'capabilities' => [],
            'notification_topics' => [],
            'timeout_mins' => nil,
            'stack_status' => '',
            'updated_time' => Time.now,
            'id' => '',
            'template_description' => ''
          }
          stored = self.data[:stacks][stack_id]
          stack.keys.each do |key|
            if(stored[key])
              stack[key] = begin; stored[key].dup; rescue TypeError; stored[key]; end
            end
          end
          if(template)
            stack['template_description'] = template.fetch('Description',
              template.fetch('description', '')
            )
          end
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'stack' => stack
          }
          response
        end
      end
    end
  end
end
