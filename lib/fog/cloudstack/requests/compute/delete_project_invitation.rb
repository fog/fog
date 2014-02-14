  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Accepts or declines project invitation
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteProjectInvitation.html]
          def delete_project_invitation(options={})
            options.merge!(
              'command' => 'deleteProjectInvitation'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
