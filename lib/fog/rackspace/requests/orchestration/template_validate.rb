module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return template for stack
        #
        # @param options [Hash] request options
        # @option options [String] :template JSON template
        # @option options [String] :template_url URL of the template
        # @return [Excon::Response]
        #   * body [Hash]
        #     * Description [String]
        #     * Parameters [Hash]
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/POST_template_validate_v1__tenant_id__validate_Templates.html
        def template_validate(options)
          request(
            :expects  => 200,
            :path => 'validate',
            :method => 'POST',
            :body => Fog::JSON.encode(options)
          )
        end

      end

      class Mock
        def template_validate(options)
          template = self.data[:stacks][:template]

          Excon::Response.new(
            :body => {
              'Description' => template.fetch('Description',
                template.fetch('description', '')
              ),
              'Parameters' => template.fetch('Parameters',
                template.fetch('parameters', {})
              )
            },
            :status => 200
          )
        end
      end
    end
  end
end
