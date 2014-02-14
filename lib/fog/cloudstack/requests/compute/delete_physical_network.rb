  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Physical Network.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deletePhysicalNetwork.html]
          def delete_physical_network(options={})
            options.merge!(
              'command' => 'deletePhysicalNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
