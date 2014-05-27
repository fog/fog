module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a baremetal dhcp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalDhcp.html]
        def add_baremetal_dhcp(options={})
          options.merge!(
            'command' => 'addBaremetalDhcp', 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'url' => options['url'], 
            'username' => options['username'], 
            'password' => options['password'], 
            'dhcpservertype' => options['dhcpservertype']  
          )
          request(options)
        end
      end

    end
  end
end

