module Fog
  module Compute
    class Cloudstack

      class Real
        # List iso visibility and all accounts that have permissions to view this iso.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listIsoPermissions.html]
        def list_iso_permissions(id, options={})
          options.merge!(
            'command' => 'listIsoPermissions', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

