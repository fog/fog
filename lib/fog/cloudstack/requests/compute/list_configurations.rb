  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all configurations.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listConfigurations.html]
          def list_configurations(options={})
            options.merge!(
              'command' => 'listConfigurations'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
