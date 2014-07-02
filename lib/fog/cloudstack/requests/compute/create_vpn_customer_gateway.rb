module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnCustomerGateway.html]
        def create_vpn_customer_gateway(gateway, cidrlist, ipsecpsk, ikepolicy, esppolicy, options={})
          options.merge!(
            'command' => 'createVpnCustomerGateway', 
            'gateway' => gateway, 
            'cidrlist' => cidrlist, 
            'ipsecpsk' => ipsecpsk, 
            'ikepolicy' => ikepolicy, 
            'esppolicy' => esppolicy  
          )
          request(options)
        end
      end

    end
  end
end

