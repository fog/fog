module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site to site vpn customer gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVpnCustomerGateways.html]
        def list_vpn_customer_gateways(options={})
          options.merge!(
            'command' => 'listVpnCustomerGateways'  
          )
          request(options)
        end
      end

    end
  end
end

