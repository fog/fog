module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site to site vpn customer gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVpnCustomerGateways.html]
        def list_vpn_customer_gateways(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVpnCustomerGateways') 
          else
            options.merge!('command' => 'listVpnCustomerGateways')
          end
          request(options)
        end
      end

    end
  end
end

