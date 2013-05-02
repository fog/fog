  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createPhysicalNetwork.html]
          def create_physical_network(options={})
            options.merge!(
              'command' => 'createPhysicalNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
