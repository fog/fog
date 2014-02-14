  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Puts storage pool into maintenance state
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/enableStorageMaintenance.html]
          def enable_storage_maintenance(options={})
            options.merge!(
              'command' => 'enableStorageMaintenance'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
