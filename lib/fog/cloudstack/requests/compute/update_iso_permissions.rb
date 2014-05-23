module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates iso permissions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateIsoPermissions.html]
        def update_iso_permissions(options={})
          options.merge!(
            'command' => 'updateIsoPermissions',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

