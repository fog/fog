module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists storage pools.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listStoragePools.html]
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
