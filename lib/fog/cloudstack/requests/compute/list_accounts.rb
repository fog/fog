  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists accounts and provides detailed account information for listed accounts
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listAccounts.html]
          def list_accounts(options={})
            options.merge!(
              'command' => 'listAccounts'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
