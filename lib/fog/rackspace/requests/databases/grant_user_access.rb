module Fog
  module Rackspace
    class Databases
      class Real
        def grant_user_access(instance_id, user, *databases)
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

          data = { :databases => [] }
          databases.each do |db_name|
            data[:databases] << { :name => db_name }
          end

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'PUT',
            :path => "instances/#{instance_id}/users/#{user}/databases"
          )
        end
      end
    end
  end
end
