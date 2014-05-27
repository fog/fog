module Fog
  module Compute
    class Cloudstack

      class Real
        # Locks an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/lockAccount.html]
        def lock_account(options={})
          options.merge!(
            'command' => 'lockAccount', 
            'account' => options['account'], 
            'domainid' => options['domainid']  
          )
          request(options)
        end
      end

    end
  end
end

