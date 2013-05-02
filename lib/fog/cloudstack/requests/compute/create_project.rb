  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createProject.html]
          def create_project(options={})
            options.merge!(
              'command' => 'createProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
