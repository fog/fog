module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteStoragePool.html]
        def delete_storage_pool(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteStoragePool') 
          else
            options.merge!('command' => 'deleteStoragePool', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

