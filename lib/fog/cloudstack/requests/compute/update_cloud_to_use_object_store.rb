module Fog
  module Compute
    class Cloudstack

      class Real
        # Migrate current NFS secondary storages to use object store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateCloudToUseObjectStore.html]
        def update_cloud_to_use_object_store(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateCloudToUseObjectStore') 
          else
            options.merge!('command' => 'updateCloudToUseObjectStore', 
            'provider' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

