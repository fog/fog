  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Registers an existing template into the CloudStack cloud. 
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/registerTemplate.html]
          def register_template(options={})
            options.merge!(
              'command' => 'registerTemplate'
            )
            request(options)
          end
           
        end # Real

        class Mock
          def register_template(options={})
            mock_template_id = self.data[:images].keys.first
            registered_template = self.data[:images][mock_template_id]

            {
                'registertemplateresponse' =>
                {
                    'count' => 1,
                    'template' => [registered_template]
                }
            }
          end
        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
