module Fog
  module Compute
    class Cloudstack

      class Real
        # List all public, private, and privileged templates.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listTemplates.html]
        def list_templates(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listTemplates')
          else
            options.merge!('command' => 'listTemplates',
            'templatefilter' => args[0])
          end

          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil

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

