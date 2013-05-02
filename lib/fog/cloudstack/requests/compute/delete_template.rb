  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a template from the system. All virtual machines using the deleted template will not be affected.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteTemplate.html]
          def delete_template(options={})
            options.merge!(
              'command' => 'deleteTemplate'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
