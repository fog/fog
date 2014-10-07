module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a baremetal dhcp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addBaremetalDhcp.html]
        def add_baremetal_dhcp(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addBaremetalDhcp') 
          else
            options.merge!('command' => 'addBaremetalDhcp', 
            'dhcpservertype' => args[0], 
            'username' => args[1], 
            'url' => args[2], 
            'physicalnetworkid' => args[3], 
            'password' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

