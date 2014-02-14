  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a network offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNetworkOffering.html]
          def delete_network_offering(options={})
            options.merge!(
              'command' => 'deleteNetworkOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
