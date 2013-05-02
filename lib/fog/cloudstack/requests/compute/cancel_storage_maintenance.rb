  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Cancels maintenance for primary storage
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/cancelStorageMaintenance.html]
          def cancel_storage_maintenance(options={})
            options.merge!(
              'command' => 'cancelStorageMaintenance'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
