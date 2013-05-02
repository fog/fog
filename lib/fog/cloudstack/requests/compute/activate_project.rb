  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Activates a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/activateProject.html]
          def activate_project(options={})
            options.merge!(
              'command' => 'activateProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
