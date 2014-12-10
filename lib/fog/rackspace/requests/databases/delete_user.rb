module Fog
  module Rackspace
    class Databases
      class Real
        def delete_user(instance_id, name)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path => "instances/#{instance_id}/users/#{name}"
          )
        end
      end
    end
  end
end
