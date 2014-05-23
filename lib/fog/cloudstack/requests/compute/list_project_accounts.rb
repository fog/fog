module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists project's accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listProjectAccounts.html]
        def list_project_accounts(options={})
          options.merge!(
            'command' => 'listProjectAccounts',
            'projectid' => options['projectid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

