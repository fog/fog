module Fog
  module Compute
    class Cloudstack

      class Real
        # Cancels maintenance for primary storage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/cancelStorageMaintenance.html]
        def cancel_storage_maintenance(id, options={})
          options.merge!(
            'command' => 'cancelStorageMaintenance', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

