  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates iso permissions
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateIsoPermissions.html]
          def update_iso_permissions(options={})
            options.merge!(
              'command' => 'updateIsoPermissions'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
