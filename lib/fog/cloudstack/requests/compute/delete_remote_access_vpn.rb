  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Destroys a l2tp/ipsec remote access vpn
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteRemoteAccessVpn.html]
          def delete_remote_access_vpn(options={})
            options.merge!(
              'command' => 'deleteRemoteAccessVpn'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
