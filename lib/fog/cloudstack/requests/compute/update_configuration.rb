  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a configuration.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateConfiguration.html]
          def update_configuration(options={})
            options.merge!(
              'command' => 'updateConfiguration'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
