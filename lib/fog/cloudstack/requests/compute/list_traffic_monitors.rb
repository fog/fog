module Fog
  module Compute
    class Cloudstack

      class Real
        # List traffic monitor Hosts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listTrafficMonitors.html]
        def list_traffic_monitors(options={})
          options.merge!(
            'command' => 'listTrafficMonitors',
            'zoneid' => options['zoneid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

