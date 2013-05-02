  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all network ACLs
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listNetworkACLs.html]
          def list_network_acls(options={})
            options.merge!(
              'command' => 'listNetworkACLs'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
