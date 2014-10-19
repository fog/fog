module Fog
  module Compute
    class Cloudstack

      class Real
        # List iso visibility and all accounts that have permissions to view this iso.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listIsoPermissions.html]
        def list_iso_permissions(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listIsoPermissions') 
          else
            options.merge!('command' => 'listIsoPermissions', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

