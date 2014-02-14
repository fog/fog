  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists remote access vpns
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listRemoteAccessVpns.html]
          def list_remote_access_vpns(options={})
            options.merge!(
              'command' => 'listRemoteAccessVpns'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
