  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Recalculate and update resource count for an account or domain.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateResourceCount.html]
          def update_resource_count(options={})
            options.merge!(
              'command' => 'updateResourceCount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
