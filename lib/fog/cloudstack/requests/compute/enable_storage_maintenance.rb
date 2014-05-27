module Fog
  module Compute
    class Cloudstack

      class Real
        # Puts storage pool into maintenance state
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableStorageMaintenance.html]
        def enable_storage_maintenance(options={})
          options.merge!(
            'command' => 'enableStorageMaintenance', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

