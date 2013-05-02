  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Network ACL
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNetworkACL.html]
          def delete_network_acl(options={})
            options.merge!(
              'command' => 'deleteNetworkACL'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
