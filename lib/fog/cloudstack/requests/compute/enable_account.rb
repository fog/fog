  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Enables an account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/enableAccount.html]
          def enable_account(options={})
            options.merge!(
              'command' => 'enableAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
