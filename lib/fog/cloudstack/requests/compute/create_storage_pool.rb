module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStoragePool.html]
        def create_storage_pool(options={})
          request(options)
        end


        def create_storage_pool(url, name, zoneid, options={})
          options.merge!(
            'command' => 'createStoragePool', 
            'url' => url, 
            'name' => name, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

