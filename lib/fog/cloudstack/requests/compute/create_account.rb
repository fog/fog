  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates an account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createAccount.html]
          def create_account(options={})
            options.merge!(
              'command' => 'createAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
