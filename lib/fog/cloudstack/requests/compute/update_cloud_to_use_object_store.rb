module Fog
  module Compute
    class Cloudstack

      class Real
        # Migrate current NFS secondary storages to use object store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateCloudToUseObjectStore.html]
        def update_cloud_to_use_object_store(options={})
          request(options)
        end


        def update_cloud_to_use_object_store(provider, options={})
          options.merge!(
            'command' => 'updateCloudToUseObjectStore', 
            'provider' => provider  
          )
          request(options)
        end
      end

    end
  end
end

