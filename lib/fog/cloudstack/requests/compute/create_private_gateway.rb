module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPrivateGateway.html]
        def create_private_gateway(options={})
          options.merge!(
            'command' => 'createPrivateGateway', 
            'gateway' => options['gateway'], 
            'vlan' => options['vlan'], 
            'vpcid' => options['vpcid'], 
            'ipaddress' => options['ipaddress'], 
            'netmask' => options['netmask']  
          )
          request(options)
        end
      end

    end
  end
end

