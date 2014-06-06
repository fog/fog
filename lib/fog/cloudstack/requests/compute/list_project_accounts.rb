module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists project's accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listProjectAccounts.html]
        def list_project_accounts(projectid, options={})
          options.merge!(
            'command' => 'listProjectAccounts', 
            'projectid' => projectid  
          )
          request(options)
        end
      end

    end
  end
end

