  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a vm group
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteInstanceGroup.html]
          def delete_instance_group(options={})
            options.merge!(
              'command' => 'deleteInstanceGroup'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
