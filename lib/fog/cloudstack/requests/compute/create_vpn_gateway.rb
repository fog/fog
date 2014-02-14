  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates site to site vpn local gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVpnGateway.html]
          def create_vpn_gateway(options={})
            options.merge!(
              'command' => 'createVpnGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
