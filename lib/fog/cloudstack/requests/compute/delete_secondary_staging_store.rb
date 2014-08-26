module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a secondary staging store .
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteSecondaryStagingStore.html]
        def delete_secondary_staging_store(id, options={})
          options.merge!(
            'command' => 'deleteSecondaryStagingStore', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

