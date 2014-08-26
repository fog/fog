module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPrivateGateway.html]
        def create_private_gateway(vpcid, gateway, ipaddress, vlan, netmask, options={})
          options.merge!(
            'command' => 'createPrivateGateway', 
            'vpcid' => vpcid, 
            'gateway' => gateway, 
            'ipaddress' => ipaddress, 
            'vlan' => vlan, 
            'netmask' => netmask  
          )
          request(options)
        end
      end

    end
  end
end

