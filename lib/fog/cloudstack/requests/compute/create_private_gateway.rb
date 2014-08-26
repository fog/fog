module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPrivateGateway.html]
        def create_private_gateway(options={})
          request(options)
        end


        def create_private_gateway(ipaddress, vlan, netmask, vpcid, gateway, options={})
          options.merge!(
            'command' => 'createPrivateGateway', 
            'ipaddress' => ipaddress, 
            'vlan' => vlan, 
            'netmask' => netmask, 
            'vpcid' => vpcid, 
            'gateway' => gateway  
          )
          request(options)
        end
      end

    end
  end
end

