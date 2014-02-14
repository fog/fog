  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Reset site to site vpn connection
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/resetVpnConnection.html]
          def reset_vpn_connection(options={})
            options.merge!(
              'command' => 'resetVpnConnection'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
