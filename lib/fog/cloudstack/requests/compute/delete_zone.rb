  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Zone.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteZone.html]
          def delete_zone(options={})
            options.merge!(
              'command' => 'deleteZone'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
