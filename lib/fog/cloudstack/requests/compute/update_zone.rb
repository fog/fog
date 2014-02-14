  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a Zone.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateZone.html]
          def update_zone(options={})
            options.merge!(
              'command' => 'updateZone'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
