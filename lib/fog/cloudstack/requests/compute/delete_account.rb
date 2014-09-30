module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a account, and all users associated with this account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAccount.html]
        def delete_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAccount') 
          else
            options.merge!('command' => 'deleteAccount', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

