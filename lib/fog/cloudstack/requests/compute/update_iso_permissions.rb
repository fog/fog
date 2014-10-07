module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates iso permissions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateIsoPermissions.html]
        def update_iso_permissions(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateIsoPermissions') 
          else
            options.merge!('command' => 'updateIsoPermissions', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

