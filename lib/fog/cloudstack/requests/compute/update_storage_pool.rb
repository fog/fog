  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a storage pool.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateStoragePool.html]
          def update_storage_pool(options={})
            options.merge!(
              'command' => 'updateStoragePool'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
