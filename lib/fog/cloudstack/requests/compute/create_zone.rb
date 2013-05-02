  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a Zone.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createZone.html]
          def create_zone(options={})
            options.merge!(
              'command' => 'createZone'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
