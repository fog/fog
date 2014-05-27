module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists secondary staging stores.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSecondaryStagingStores.html]
        def list_secondary_staging_stores(options={})
          options.merge!(
            'command' => 'listSecondaryStagingStores'  
          )
          request(options)
        end
      end

    end
  end
end

