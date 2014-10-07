module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a template visibility permissions. A public template is visible to all accounts within the same domain. A private template is visible only to the owner of the template. A priviledged template is a private template with account permissions added. Only accounts specified under the template permissions are visible to them.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateTemplatePermissions.html]
        def update_template_permissions(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateTemplatePermissions') 
          else
            options.merge!('command' => 'updateTemplatePermissions', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

