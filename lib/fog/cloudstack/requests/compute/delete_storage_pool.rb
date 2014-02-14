  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a storage pool.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteStoragePool.html]
          def delete_storage_pool(options={})
            options.merge!(
              'command' => 'deleteStoragePool'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
