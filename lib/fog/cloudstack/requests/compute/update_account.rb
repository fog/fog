  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates account information for the authenticated user
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateAccount.html]
          def update_account(options={})
            options.merge!(
              'command' => 'updateAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
