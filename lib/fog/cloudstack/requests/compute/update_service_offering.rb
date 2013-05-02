  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a service offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateServiceOffering.html]
          def update_service_offering(options={})
            options.merge!(
              'command' => 'updateServiceOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
