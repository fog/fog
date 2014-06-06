module Fog
  module Compute
    class Cloudstack

      class Real
        # List all public, private, and privileged templates.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listTemplates.html]
        def list_templates(templatefilter, options={})
          options.merge!(
            'command' => 'listTemplates', 
            'templatefilter' => templatefilter  
          )
          request(options)
        end
      end
 
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
      end 
    end
  end
end

