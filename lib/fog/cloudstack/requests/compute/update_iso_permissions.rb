module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates iso permissions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateIsoPermissions.html]
        def update_iso_permissions(id, options={})
          options.merge!(
            'command' => 'updateIsoPermissions', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

