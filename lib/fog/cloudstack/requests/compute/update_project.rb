  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateProject.html]
          def update_project(options={})
            options.merge!(
              'command' => 'updateProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
