module Fog
  module Orchestration
    class Rackspace
      class Real

        # Create a stack.
        #
        # @param stack_name [String] name of the stack
        # @param options [Hash]
        # @option options [String] :template template body
        # @option options [String] :template_url URL of the file containing the template body
        # @option options [TrueClass, FalseClass] :disable_rollback control rollback on stack failure
        # @option options [Hash] :parameters parameters for template
        # @option options [Integer] :timeout_mins timeout for stack creation in minutes
        #
        # @return [Excon::Response]
        #   * body [Hash]:
        #     * stack [Hash]:
        #       * id [String]
        #       * links [Array]
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/POST_stack_create_v1__tenant_id__stacks_Stack_Operations.html
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
            'links' => [{"href"=>"http://localhost:8004/v1/fake_tenant_id/stacks/#{stack_name}/#{stack_id}", "rel"=>"self"}],
            'description' => options[:description],
            'stack_status' => 'CREATE_COMPLETE',
            'stack_status_reason' => 'Stack successfully created',
            'creation_time' => Time.now.to_s,
            'updated_time' => Time.now.to_s
          }.merge(Fog::JSON.decode(Fog::JSON.encode(options)))

          response = Excon::Response.new
          response.status = 201
          response.body = {
            'stack' => {
              'id' => stack_id,
              'links'=> stack['links']
            }
          }
          response
        end
      end
    end
  end
end
