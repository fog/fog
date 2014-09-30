module Fog
  module Rackspace
    class Databases
      class Real
        def revoke_user_access(instance_id, user, database)
          user =
            if user.respond_to?(:name) && user.respond_to?(:host) 
              host_str = 
                if user.host && user.host != '' && user.host != '%'
                  "@#{user.host}"
                end.to_s
              user.name + host_str
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
