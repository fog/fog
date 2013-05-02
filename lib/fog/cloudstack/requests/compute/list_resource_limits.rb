  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists resource limits.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listResourceLimits.html]
          def list_resource_limits(options={})
            options.merge!(
              'command' => 'listResourceLimits'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
