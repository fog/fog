module Fog
  module Compute
    class Cloudstack

      class Real
        # Locks an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/lockAccount.html]
        def lock_account(account, domainid, options={})
          options.merge!(
            'command' => 'lockAccount', 
            'account' => account, 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

