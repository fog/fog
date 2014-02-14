  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Suspends a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/suspendProject.html]
          def suspend_project(options={})
            options.merge!(
              'command' => 'suspendProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
