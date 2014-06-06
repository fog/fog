module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn local gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnGateway.html]
        def create_vpn_gateway(vpcid, options={})
          options.merge!(
            'command' => 'createVpnGateway', 
            'vpcid' => vpcid  
          )
          request(options)
        end
      end

    end
  end
end

