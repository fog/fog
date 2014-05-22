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
            'dhcpservertype' => options['dhcpservertype'], 
            'password' => options['password'], 
            'url' => options['url'], 
            'username' => options['username'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

