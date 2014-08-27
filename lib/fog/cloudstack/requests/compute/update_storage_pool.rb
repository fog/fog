module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateStoragePool.html]
        def update_storage_pool(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateStoragePool') 
          else
            options.merge!('command' => 'updateStoragePool', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

