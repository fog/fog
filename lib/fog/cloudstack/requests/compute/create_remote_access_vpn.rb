  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a l2tp/ipsec remote access vpn
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createRemoteAccessVpn.html]
          def create_remote_access_vpn(options={})
            options.merge!(
              'command' => 'createRemoteAccessVpn'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
