  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a network offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateNetworkOffering.html]
          def update_network_offering(options={})
            options.merge!(
              'command' => 'updateNetworkOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
