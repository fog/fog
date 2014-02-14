  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List all public, private, and privileged templates.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listTemplates.html]
          def list_templates(options={})
            options.merge!(
              'command' => 'listTemplates'
            )
            request(options)
          end
           
        end # Real

        class Mock

          def list_templates(options={})
            templates = self.data[:images].values

            {
              "listtemplatesresponse" =>
                {
                  "count" => templates.size,
                  "template"=> templates
                }
            }
          end
        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
