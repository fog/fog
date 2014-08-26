module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage pools.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listStoragePools.html]
        def list_storage_pools(options={})
          options.merge!(
            'command' => 'listStoragePools'  
          )
          request(options)
        end
      end

    end
  end
end

