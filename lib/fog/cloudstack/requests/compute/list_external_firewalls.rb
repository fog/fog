module Fog
  module Compute
    class Cloudstack

      class Real
        # List external firewall appliances.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listExternalFirewalls.html]
        def list_external_firewalls(zoneid, options={})
          options.merge!(
            'command' => 'listExternalFirewalls', 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

