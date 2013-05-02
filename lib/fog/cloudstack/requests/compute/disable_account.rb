  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Disables an account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/disableAccount.html]
          def disable_account(options={})
            options.merge!(
              'command' => 'disableAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
