  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes an traffic monitor host.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteTrafficMonitor.html]
          def delete_traffic_monitor(options={})
            options.merge!(
              'command' => 'deleteTrafficMonitor'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
