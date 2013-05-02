  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a account, and all users associated with this account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteAccount.html]
          def delete_account(options={})
            options.merge!(
              'command' => 'deleteAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
