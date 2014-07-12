module Fog
  module Compute
    class Cloudstack

      class Real
        # Update site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVpnCustomerGateway.html]
        def update_vpn_customer_gateway(id, esppolicy, ikepolicy, cidrlist, gateway, ipsecpsk, options={})
          options.merge!(
            'command' => 'updateVpnCustomerGateway', 
            'id' => id, 
            'esppolicy' => esppolicy, 
            'ikepolicy' => ikepolicy, 
            'cidrlist' => cidrlist, 
            'gateway' => gateway, 
            'ipsecpsk' => ipsecpsk  
          )
          request(options)
        end
      end

    end
  end
end

