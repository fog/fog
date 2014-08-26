module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a baremetal dhcp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalDhcp.html]
        def add_baremetal_dhcp(options={})
          request(options)
        end


        def add_baremetal_dhcp(dhcpservertype, username, url, physicalnetworkid, password, options={})
          options.merge!(
            'command' => 'addBaremetalDhcp', 
            'dhcpservertype' => dhcpservertype, 
            'username' => username, 
            'url' => url, 
            'physicalnetworkid' => physicalnetworkid, 
            'password' => password  
          )
          request(options)
        end
      end

    end
  end
end

