  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Create site to site vpn connection
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVpnConnection.html]
          def create_vpn_connection(options={})
            options.merge!(
              'command' => 'createVpnConnection'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
