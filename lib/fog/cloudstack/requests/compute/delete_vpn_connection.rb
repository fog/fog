  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Delete site to site vpn connection
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteVpnConnection.html]
          def delete_vpn_connection(options={})
            options.merge!(
              'command' => 'deleteVpnConnection'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
