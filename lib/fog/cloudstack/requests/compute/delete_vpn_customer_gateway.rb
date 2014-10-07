module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete site to site vpn customer gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVpnCustomerGateway.html]
        def delete_vpn_customer_gateway(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVpnCustomerGateway') 
          else
            options.merge!('command' => 'deleteVpnCustomerGateway', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

