module Fog
  module Compute
    class Cloudstack

      class Real
        # Update site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVpnCustomerGateway.html]
        def update_vpn_customer_gateway(options={})
          options.merge!(
            'command' => 'updateVpnCustomerGateway', 
            'ipsecpsk' => options['ipsecpsk'], 
            'ikepolicy' => options['ikepolicy'], 
            'id' => options['id'], 
            'gateway' => options['gateway'], 
            'esppolicy' => options['esppolicy'], 
            'cidrlist' => options['cidrlist']  
          )
          request(options)
        end
      end

    end
  end
end

