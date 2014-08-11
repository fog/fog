module Fog
  module Rackspace
    class Databases
      class Real
        def revoke_user_access(instance_id, user_name, database)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path => "instances/#{instance_id}/users/#{user_name}/databases/#{database}"
          )
        end
      end
    end
  end
end
