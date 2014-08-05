module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disableAccount.html]
        def disable_account(lock, options={})
          options.merge!(
            'command' => 'disableAccount', 
            'lock' => lock  
          )
          request(options)
        end
      end

    end
  end
end

