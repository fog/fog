module Fog
  module Compute
    class Cloudstack

      class Real
        # Accepts or declines project invitation
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteProjectInvitation.html]
        def delete_project_invitation(id, options={})
          options.merge!(
            'command' => 'deleteProjectInvitation', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

