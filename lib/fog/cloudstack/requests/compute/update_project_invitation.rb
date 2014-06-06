module Fog
  module Compute
    class Cloudstack

      class Real
        # Accepts or declines project invitation
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateProjectInvitation.html]
        def update_project_invitation(projectid, options={})
          options.merge!(
            'command' => 'updateProjectInvitation', 
            'projectid' => projectid  
          )
          request(options)
        end
      end

    end
  end
end

