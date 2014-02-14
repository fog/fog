  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds acoount to a project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addAccountToProject.html]
          def add_account_to_project(options={})
            options.merge!(
              'command' => 'addAccountToProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
