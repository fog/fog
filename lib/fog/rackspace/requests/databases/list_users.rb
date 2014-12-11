module Fog
  module Rackspace
    class Databases
      class Real
        def list_users(instance_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "instances/#{instance_id}/users"
          )
        end
      end
    end
  end
end
