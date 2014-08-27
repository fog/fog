module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an traffic monitor host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteTrafficMonitor.html]
        def delete_traffic_monitor(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteTrafficMonitor') 
          else
            options.merge!('command' => 'deleteTrafficMonitor', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

