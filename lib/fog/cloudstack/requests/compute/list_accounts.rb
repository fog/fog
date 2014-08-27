module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists accounts and provides detailed account information for listed accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAccounts.html]
        def list_accounts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAccounts') 
          else
            options.merge!('command' => 'listAccounts')
          end
          request(options)
        end
      end

    end
  end
end

