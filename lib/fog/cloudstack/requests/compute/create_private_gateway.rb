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
            'vpcid' => options['vpcid'], 
            'ipaddress' => options['ipaddress'], 
            'gateway' => options['gateway'], 
            'vlan' => options['vlan'], 
            'netmask' => options['netmask']  
          )
          request(options)
        end
      end

    end
  end
end

