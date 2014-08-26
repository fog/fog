module Fog
  module Compute
    class Cloudstack

      class Real
        # Update site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVpnCustomerGateway.html]
        def update_vpn_customer_gateway(options={})
          request(options)
        end


        def update_vpn_customer_gateway(id, gateway, cidrlist, ipsecpsk, esppolicy, ikepolicy, options={})
          options.merge!(
            'command' => 'updateVpnCustomerGateway', 
            'id' => id, 
            'gateway' => gateway, 
            'cidrlist' => cidrlist, 
            'ipsecpsk' => ipsecpsk, 
            'esppolicy' => esppolicy, 
            'ikepolicy' => ikepolicy  
          )
          request(options)
        end
      end

    end
  end
end

