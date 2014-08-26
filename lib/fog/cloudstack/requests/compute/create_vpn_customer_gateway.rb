module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnCustomerGateway.html]
        def create_vpn_customer_gateway(options={})
          request(options)
        end


        def create_vpn_customer_gateway(esppolicy, cidrlist, ikepolicy, gateway, ipsecpsk, options={})
          options.merge!(
            'command' => 'createVpnCustomerGateway', 
            'esppolicy' => esppolicy, 
            'cidrlist' => cidrlist, 
            'ikepolicy' => ikepolicy, 
            'gateway' => gateway, 
            'ipsecpsk' => ipsecpsk  
          )
          request(options)
        end
      end

    end
  end
end

