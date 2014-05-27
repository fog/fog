module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds Traffic Monitor Host for Direct Network Usage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addTrafficMonitor.html]
        def add_traffic_monitor(options={})
          options.merge!(
            'command' => 'addTrafficMonitor', 
            'zoneid' => options['zoneid'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

