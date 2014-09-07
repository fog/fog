module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage providers.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listStorageProviders.html]
        def list_storage_providers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listStorageProviders') 
          else
            options.merge!('command' => 'listStorageProviders', 
            'type' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

