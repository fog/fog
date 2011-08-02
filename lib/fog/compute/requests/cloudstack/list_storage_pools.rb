module Fog
  module Compute
    class Cloudstack
      class Real

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
