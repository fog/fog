module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage providers.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listStorageProviders.html]
        def list_storage_providers(type, options={})
          options.merge!(
            'command' => 'listStorageProviders', 
            'type' => type  
          )
          request(options)
        end
      end

    end
  end
end

