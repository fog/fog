module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete one or more alerts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAlerts.html]
        def delete_alerts(options={})
          options.merge!(
            'command' => 'deleteAlerts'  
          )
          request(options)
        end
      end

    end
  end
end

