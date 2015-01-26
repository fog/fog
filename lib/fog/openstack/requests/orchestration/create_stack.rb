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
            :expects  => 201,
            :path => 'stacks',
            :method => 'POST',
            :body => Fog::JSON.encode(params)
          )
        end
      end

      class Mock
        def create_stack(stack_name, options = {})
          stack_id = Fog::Mock.random_hex(32)
          stack = self.data[:stacks][stack_id] = {
            'id' => stack_id,
            'stack_name' => stack_name,
            'links' => [],
            'description' => options[:description],
            'stack_status' => 'CREATE_COMPLETE',
            'stack_status_reason' => 'Stack successfully created',
            'creation_time' => Time.now,
            'updated_time' => Time.now
          }

          response = Excon::Response.new
          response.status = 201
          response.body = {
            'id' => stack_id,
            'links'=>[{"href"=>"http://localhost:8004/v1/fake_tenant_id/stacks/#{stack_name}/#{stack_id}", "rel"=>"self"}]}
          response
        end
      end
    end
  end
end
