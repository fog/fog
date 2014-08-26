module Fog
  module Compute
    class Cloudstack

      class Real
        # List traffic monitor Hosts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listTrafficMonitors.html]
        def list_traffic_monitors(zoneid, options={})
          options.merge!(
            'command' => 'listTrafficMonitors', 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

