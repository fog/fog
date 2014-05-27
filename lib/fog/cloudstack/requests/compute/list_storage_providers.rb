module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage providers.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listStorageProviders.html]
        def list_storage_providers(options={})
          options.merge!(
            'command' => 'listStorageProviders', 
            'type' => options['type']  
          )
          request(options)
        end
      end

    end
  end
end

