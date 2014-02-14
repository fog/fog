  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Delete site to site vpn gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteVpnGateway.html]
          def delete_vpn_gateway(options={})
            options.merge!(
              'command' => 'deleteVpnGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
