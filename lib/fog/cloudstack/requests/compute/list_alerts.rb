module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all alerts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAlerts.html]
        def list_alerts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAlerts') 
          else
            options.merge!('command' => 'listAlerts')
          end
          request(options)
        end
      end

    end
  end
end

