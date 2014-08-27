module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds Traffic Monitor Host for Direct Network Usage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addTrafficMonitor.html]
        def add_traffic_monitor(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addTrafficMonitor') 
          else
            options.merge!('command' => 'addTrafficMonitor', 
            'zoneid' => args[0], 
            'url' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

