module Fog
  module Orchestration
    class Rackspace
      class Real

        # Update a stack.
        #
        # @param [String] stack_id ID of the stack to update.
        # @param [String] stack_name Name of the stack to update.
        # @param [Hash] options
        # @option options [String] :template template body
        # @option options [String] :template_url URL of file containing template body
        # @option options [Hash] :parameters stack parameters
        # @return [Excon::Response]
        #   * body [String] accept message
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/PUT_stack_update_v1__tenant_id__stacks__stack_name___stack_id__Stack_Operations.html
        def update_stack(stack_id, stack_name, options = {})
          params = {
            :stack_name => stack_name
          }.merge(options)
          request(
            :expects  => 202,
            :path => "stacks/#{stack_name}/#{stack_id}",
            :method => 'PUT',
            :body => Fog::JSON.encode(params)
          )
        end

      end

      class Mock
        def update_stack(stack_name, options = {})
          response = Excon::Response.new
          response.status = 202
          response.body = 'Update acceptance message'
          response
        end
      end
    end
  end
end
