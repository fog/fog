  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates site to site vpn customer gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVpnCustomerGateway.html]
          def create_vpn_customer_gateway(options={})
            options.merge!(
              'command' => 'createVpnCustomerGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
