module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a template visibility permissions. A public template is visible to all accounts within the same domain. A private template is visible only to the owner of the template. A priviledged template is a private template with account permissions added. Only accounts specified under the template permissions are visible to them.
        #
        # ==== Parameters
        # * id<~Integer>: The template ID
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/updateTemplatePermissions.html]
        def update_template_permissions(id, options={})
          options.merge!(
            'command' => 'updateTemplatePermissions',
            'id'      => id
          )

          request(options)
        end
      end

      class Mock
        def update_template_permissions(id, options={})
          {
            "updatetemplatepermissionsresponse" => {
              "success"     => true,
              "displaytext" => "success"
            }
          }
        end
      end
    end
  end
end