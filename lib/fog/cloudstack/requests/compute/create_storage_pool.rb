module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStoragePool.html]
        def create_storage_pool(url, zoneid, name, options={})
          options.merge!(
            'command' => 'createStoragePool', 
            'url' => url, 
            'zoneid' => zoneid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

