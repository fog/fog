  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all alerts.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listAlerts.html]
          def list_alerts(options={})
            options.merge!(
              'command' => 'listAlerts'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
