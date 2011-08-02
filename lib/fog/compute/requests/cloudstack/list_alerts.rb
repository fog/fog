module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all alerts.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listAlerts.html]
        def list_alerts(options={})
          options.merge!(
            'command' => 'listAlerts'
          )
          
          request(options)
        end

      end
    end
  end
end
