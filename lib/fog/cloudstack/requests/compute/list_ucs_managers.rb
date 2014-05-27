module Fog
  module Compute
    class Cloudstack

      class Real
        # List ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUcsManagers.html]
        def list_ucs_managers(options={})
          options.merge!(
            'command' => 'listUcsManagers'  
          )
          request(options)
        end
      end

    end
  end
end

