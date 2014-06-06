module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteStoragePool.html]
        def delete_storage_pool(id, options={})
          options.merge!(
            'command' => 'deleteStoragePool', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

