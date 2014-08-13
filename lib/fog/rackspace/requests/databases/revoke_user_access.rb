module Fog
  module Rackspace
    class Databases
      class Real
        def revoke_user_access(instance_id, user, database)
          user  = 
            if user.respond_to?(:name) && user.respond_to?(:host) 
              if user.host == '%'
                user.name
              else
                "#{user.name}@#{user.host}"
              end
            else
              user
            end

          request(
            :expects => 202,
            :method => 'DELETE',
            :path => "instances/#{instance_id}/users/#{user}/databases/#{database}"
          )
        end
      end
    end
  end
end
