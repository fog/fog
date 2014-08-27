module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVpnCustomerGateway.html]
        def create_vpn_customer_gateway(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVpnCustomerGateway') 
          else
            options.merge!('command' => 'createVpnCustomerGateway', 
            'esppolicy' => args[0], 
            'cidrlist' => args[1], 
            'ikepolicy' => args[2], 
            'gateway' => args[3], 
            'ipsecpsk' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

