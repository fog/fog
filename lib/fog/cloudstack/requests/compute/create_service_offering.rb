  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a service offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createServiceOffering.html]
          def create_service_offering(options={})
            options.merge!(
              'command' => 'createServiceOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
