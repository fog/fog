module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a storage pool.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStoragePool.html]
        def create_storage_pool(options={})
          options.merge!(
            'command' => 'createStoragePool', 
            'zoneid' => options['zoneid'], 
            'name' => options['name'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

