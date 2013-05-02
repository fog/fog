  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Removes vpn user
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/removeVpnUser.html]
          def remove_vpn_user(options={})
            options.merge!(
              'command' => 'removeVpnUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
