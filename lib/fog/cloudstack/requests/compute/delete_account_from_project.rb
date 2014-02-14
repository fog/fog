  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes account from the project
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteAccountFromProject.html]
          def delete_account_from_project(options={})
            options.merge!(
              'command' => 'deleteAccountFromProject'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
