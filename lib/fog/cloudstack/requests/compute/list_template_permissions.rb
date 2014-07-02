module Fog
  module Compute
    class Cloudstack

      class Real
        # List template visibility and all accounts that have permissions to view this template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listTemplatePermissions.html]
        def list_template_permissions(id, options={})
          options.merge!(
            'command' => 'listTemplatePermissions', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

