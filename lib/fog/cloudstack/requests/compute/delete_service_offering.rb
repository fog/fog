  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a service offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteServiceOffering.html]
          def delete_service_offering(options={})
            options.merge!(
              'command' => 'deleteServiceOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
