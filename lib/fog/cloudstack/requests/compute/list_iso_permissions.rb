  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List template visibility and all accounts that have permissions to view this template.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listIsoPermissions.html]
          def list_iso_permissions(options={})
            options.merge!(
              'command' => 'listIsoPermissions'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
