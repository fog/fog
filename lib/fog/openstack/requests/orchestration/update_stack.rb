module Fog
  module Orchestration
    class OpenStack
      class Real

        # Update a stack.
        #
        # @param [String] stack_name Name of the stack to update.
        # @param [Hash] options
        #   * :template_body [String] Structure containing the template body.
        #   or (one of the two Template parameters is required)
        #   * :template_url [String] URL of file containing the template body.
        #   * :parameters [Hash] Hash of providers to supply to template.
        #
        # @see http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_UpdateStack.html
        #
        def update_stack(stack_name, options = {})
          params = {
            :stack_name => stack_name
          }.merge(options)

          request(
            :path => 'stacks',
            :method => 'PUT',
            :body => MultiJson.encode(params)
          )
        end

      end

      class Mock
        def update_stack(stack_name, options = {})
          response = Excon::Response.new
          response.status = 202
          response.body = {}
          response
        end
      end
    end
  end
end
