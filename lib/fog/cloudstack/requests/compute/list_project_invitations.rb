module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists projects and provides detailed information for listed projects
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listProjectInvitations.html]
        def list_project_invitations(options={})
          options.merge!(
            'command' => 'listProjectInvitations'  
          )
          request(options)
        end
      end

    end
  end
end

