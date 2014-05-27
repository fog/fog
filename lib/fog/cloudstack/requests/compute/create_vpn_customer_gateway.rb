module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnCustomerGateway.html]
        def create_vpn_customer_gateway(options={})
          options.merge!(
            'command' => 'createVpnCustomerGateway', 
            'cidrlist' => options['cidrlist'], 
            'esppolicy' => options['esppolicy'], 
            'gateway' => options['gateway'], 
            'ipsecpsk' => options['ipsecpsk'], 
            'ikepolicy' => options['ikepolicy']  
          )
          request(options)
        end
      end

    end
  end
end

