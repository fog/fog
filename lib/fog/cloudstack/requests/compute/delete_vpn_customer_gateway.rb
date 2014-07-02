module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVpnCustomerGateway.html]
        def delete_vpn_customer_gateway(id, options={})
          options.merge!(
            'command' => 'deleteVpnCustomerGateway', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

