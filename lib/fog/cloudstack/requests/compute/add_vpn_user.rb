  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds vpn users
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addVpnUser.html]
          def add_vpn_user(options={})
            options.merge!(
              'command' => 'addVpnUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
