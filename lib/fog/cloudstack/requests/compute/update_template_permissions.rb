  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a template visibility permissions. A public template is visible to all accounts within the same domain. A private template is visible only to the owner of the template. A priviledged template is a private template with account permissions added. Only accounts specified under the template permissions are visible to them.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateTemplatePermissions.html]
          def update_template_permissions(options={})
            options.merge!(
              'command' => 'updateTemplatePermissions'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
