module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return template for stack
        #
        # @param stack_name [String]
        # @param stack_id   [String] The unique identifer for a stack
        # @return [Excon::Response]
        #   * body [Hash] template
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_template_v1__tenant_id__stacks__stack_name___stack_id__template_Templates.html
        def template_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'template'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock
        def template(stack_name, stack_id)
          Excon::Response.new(
            :body => self.data[:stacks][:template],
            :status => 200
          )
        end
      end
    end
  end
end
