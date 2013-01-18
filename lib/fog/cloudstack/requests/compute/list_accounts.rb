module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists accounts and provides detailed account information for listed accounts.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listAccounts.html]
        def list_accounts(options={})
          options.merge!(
            'command' => 'listAccounts'
          )
          
          request(options)
        end

      end
    end
  end
end
