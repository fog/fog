  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Update site to site vpn customer gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateVpnCustomerGateway.html]
          def update_vpn_customer_gateway(options={})
            options.merge!(
              'command' => 'updateVpnCustomerGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
