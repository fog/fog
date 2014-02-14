  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteProject.html]
          def delete_project(options={})
            options.merge!(
              'command' => 'deleteProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
