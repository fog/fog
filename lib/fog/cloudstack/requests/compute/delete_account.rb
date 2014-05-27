module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a account, and all users associated with this account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAccount.html]
        def delete_account(options={})
          options.merge!(
            'command' => 'deleteAccount', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

