module Fog
  module Rackspace
    class Databases
      class Real
        def grant_user_access(instance_id, user_name, *databases)
          data = { :databases => [] }
          databases.each do |db_name|
            data[:databases] << { :name => db_name }
          end

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'PUT',
            :path => "instances/#{instance_id}/users/#{user_name}/databases"
          )
        end
      end
    end
  end
end
