module Fog
  module Compute
    class Cloudstack

      class Real
        # Archive one or more alerts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/archiveAlerts.html]
        def archive_alerts(options={})
          options.merge!(
            'command' => 'archiveAlerts'  
          )
          request(options)
        end
      end

    end
  end
end

