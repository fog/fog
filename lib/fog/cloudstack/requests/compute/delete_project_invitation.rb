module Fog
  module Compute
    class Cloudstack

      class Real
        # Accepts or declines project invitation
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteProjectInvitation.html]
        def delete_project_invitation(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteProjectInvitation') 
          else
            options.merge!('command' => 'deleteProjectInvitation', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

