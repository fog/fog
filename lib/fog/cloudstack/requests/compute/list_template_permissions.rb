module Fog
  module Compute
    class Cloudstack
      class Real

        # List template visibility and all accounts that have permissions to view this template.
        #
        # ==== Parameters
        # * id<~Integer>: The template ID
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listTemplatePermissions.html]
        def list_template_permissions(id, options={})
          options.merge!(
            'command' => 'listTemplatePermissions',
            'id'      => id
          )

          request(options)
        end
      end

      class Mock
        def list_template_permissions(id, options={})
          {
            "listtemplatepermissionsresponse" => {
              "templatepermission" => {
                "ispublic"  => true,
                "account"   => [],
                "id"        => 206,
                "domainid"  => 1
              }
            }
          }
        end
      end
    end
  end
end