module Fog
  module Compute
    class Cloudstack

      class Real
        # Archive one or more alerts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/archiveAlerts.html]
        def archive_alerts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'archiveAlerts') 
          else
            options.merge!('command' => 'archiveAlerts')
          end
          request(options)
        end
      end

    end
  end
end

