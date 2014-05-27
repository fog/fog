module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes account from the project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAccountFromProject.html]
        def delete_account_from_project(options={})
          options.merge!(
            'command' => 'deleteAccountFromProject', 
            'account' => options['account'], 
            'projectid' => options['projectid']  
          )
          request(options)
        end
      end

    end
  end
end

