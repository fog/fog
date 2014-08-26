module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a baremetal dhcp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalDhcp.html]
        def add_baremetal_dhcp(dhcpservertype, physicalnetworkid, username, url, password, options={})
          options.merge!(
            'command' => 'addBaremetalDhcp', 
            'dhcpservertype' => dhcpservertype, 
            'physicalnetworkid' => physicalnetworkid, 
            'username' => username, 
            'url' => url, 
            'password' => password  
          )
          request(options)
        end
      end

    end
  end
end

