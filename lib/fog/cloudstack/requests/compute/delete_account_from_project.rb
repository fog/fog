module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes account from the project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAccountFromProject.html]
        def delete_account_from_project(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAccountFromProject') 
          else
            options.merge!('command' => 'deleteAccountFromProject', 
            'projectid' => args[0], 
            'account' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

