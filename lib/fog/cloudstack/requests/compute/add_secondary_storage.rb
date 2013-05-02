  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds secondary storage.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addSecondaryStorage.html]
          def add_secondary_storage(options={})
            options.merge!(
              'command' => 'addSecondaryStorage'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
