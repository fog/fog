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
          if(options[:template])
            begin
              template = Fog::JSON.decode(options[:template])
              result = {
                'Description' => template.fetch('Description',
                  template.fetch('description', '')
                ),
                'Parameters' => template.fetch('Parameters',
                  template.fetch('parameters', {})
                )
              }
              result['Parameters'].values.each do |param|
                param['Type'] = 'String' unless param['Type']
              end

              Excon::Response.new(
                :body => result,
                :status => 200
              )
            rescue => e
              raise BadRequest.new(e.message)
            end
          else
            raise NotImplementedError.new ':template_url not currently mocked'
          end
        end
      end
    end
  end
end
