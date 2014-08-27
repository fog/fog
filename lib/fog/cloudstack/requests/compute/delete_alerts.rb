module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete one or more alerts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAlerts.html]
        def delete_alerts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAlerts') 
          else
            options.merge!('command' => 'deleteAlerts')
          end
          request(options)
        end
      end

    end
  end
end

