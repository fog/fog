module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage pools.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listStoragePools.html]
        def list_storage_pools(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listStoragePools') 
          else
            options.merge!('command' => 'listStoragePools')
          end
          request(options)
        end
      end

    end
  end
end

