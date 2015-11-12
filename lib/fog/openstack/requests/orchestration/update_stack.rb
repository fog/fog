module Fog
  module Orchestration
    class OpenStack
      class Real
        # Update a stack.
        #
        # @param [Fog::Orchestration::OpenStack::Stack] the stack to update.
        # @param [Hash] options
        #   * :template [String] Structure containing the template body.
        #   or (one of the two Template parameters is required)
        #   * :template_url [String] URL of file containing the template body.
        #   * :parameters [Hash] Hash of providers to supply to template.
        #
        def update_stack(arg1, arg2 = nil, arg3 = nil)
          if arg1.is_a?(Stack)
            # Normal use, update_stack(stack, options = {})
            stack = arg1
            stack_name = stack.stack_name
            stack_id = stack.id
            params = arg2.nil? ? {} : arg2
          else
            # Deprecated, update_stack(stack_id, stack_name, options = {})
            Fog::Logger.deprecation("#update_stack(stack_id, stack_name, options) is deprecated, use #update_stack(stack, options) instead [light_black](#{caller.first})[/]")
            stack_id = arg1
            stack_name = arg2
            params = {
              :stack_name => stack_name
            }.merge(arg3.nil? ? {} : arg3)
          end

          request(
            :expects  => 202,
            :path => "stacks/#{stack_name}/#{stack_id}",
            :method => 'PUT',
            :body => Fog::JSON.encode(params)
          )
        end
      end

      class Mock
        def update_stack(arg1, arg2 = nil, arg3 = nil)
          if arg1.is_a?(Stack)
            # Normal use, update_stack(stack, options = {})
            stack = arg1
            stack_name = stack.stack_name
            stack_id = stack.id
            params = arg2.nil? ? {} : arg2
          else
            # Deprecated, update_stack(stack_id, stack_name, options = {})
            Fog::Logger.deprecation("#update_stack(stack_id, stack_name, options) is deprecated, use #update_stack(stack, options) instead [light_black](#{caller.first})[/]")
            stack_id = arg1
            stack_name = arg2
            params = {
              :stack_name => stack_name
            }.merge(arg3.nil? ? {} : arg3)
          end

          response = Excon::Response.new
          response.status = 202
          response.body = {}
          response
        end
      end
    end
  end
end
