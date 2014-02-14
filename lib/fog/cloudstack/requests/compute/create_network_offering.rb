  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a network offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createNetworkOffering.html]
          def create_network_offering(options={})
            options.merge!(
              'command' => 'createNetworkOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
