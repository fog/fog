  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a storage pool.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createStoragePool.html]
          def create_storage_pool(options={})
            options.merge!(
              'command' => 'createStoragePool'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
