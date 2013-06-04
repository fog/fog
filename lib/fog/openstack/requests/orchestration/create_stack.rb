module Fog
  module Orchestration
    class OpenStack
      class Real

        # Create a stack.
        # 
        # * stack_name [String] Name of the stack to create.
        # * options [Hash]:
        #   * :template_body [String] Structure containing the template body.
        #   or (one of the two Template parameters is required)
        #   * :template_url [String] URL of file containing the template body.
        #   * :disable_rollback [Boolean] Controls rollback on stack creation failure, defaults to false.
        #   * :parameters [Hash] Hash of providers to supply to template
        #   * :timeout_in_minutes [Integer] Minutes to wait before status is set to CREATE_FAILED
        #
        # @see http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
        
        def create_stack(stack_name, options = {})
          params = {
            :stack_name => stack_name
          }.merge(options)

          request(
            :path => 'stacks',
            :method => 'POST',
            :body => MultiJson.encode(params)
          )
        end

      end
      
      class Mock
        def create_stack(stack_name, options = {})
          response = Excon::Response.new
          response.status = 202
          response.body = {}
          response
        end
      end
    end
  end
end
