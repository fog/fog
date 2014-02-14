  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updatePhysicalNetwork.html]
          def update_physical_network(options={})
            options.merge!(
              'command' => 'updatePhysicalNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
