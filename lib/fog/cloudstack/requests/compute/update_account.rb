module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates account information for the authenticated user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateAccount.html]
        def update_account(newname, options={})
          options.merge!(
            'command' => 'updateAccount', 
            'newname' => newname  
          )
          request(options)
        end
      end

    end
  end
end

