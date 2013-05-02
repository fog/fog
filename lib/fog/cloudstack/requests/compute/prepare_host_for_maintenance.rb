  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Prepares a host for maintenance.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/prepareHostForMaintenance.html]
          def prepare_host_for_maintenance(options={})
            options.merge!(
              'command' => 'prepareHostForMaintenance'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
