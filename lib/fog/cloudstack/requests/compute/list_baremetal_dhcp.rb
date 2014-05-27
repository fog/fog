module Fog
  module Compute
    class Cloudstack

      class Real
        # list baremetal dhcp servers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listBaremetalDhcp.html]
        def list_baremetal_dhcp(options={})
          options.merge!(
            'command' => 'listBaremetalDhcp'  
          )
          request(options)
        end
      end

    end
  end
end

