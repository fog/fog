  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Cancels host maintenance.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/cancelHostMaintenance.html]
          def cancel_host_maintenance(options={})
            options.merge!(
              'command' => 'cancelHostMaintenance'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
