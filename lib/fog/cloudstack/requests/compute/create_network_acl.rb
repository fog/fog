  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a ACL rule the given network (the network has to belong to VPC)
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createNetworkACL.html]
          def create_network_acl(options={})
            options.merge!(
              'command' => 'createNetworkACL'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
