module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableAccount.html]
        def enable_account(options={})
          options.merge!(
            'command' => 'enableAccount'  
          )
          request(options)
        end
      end

    end
  end
end

