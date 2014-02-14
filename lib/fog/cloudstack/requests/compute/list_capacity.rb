  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all the system wide capacities.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listCapacity.html]
          def list_capacity(options={})
            options.merge!(
              'command' => 'listCapacity'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
