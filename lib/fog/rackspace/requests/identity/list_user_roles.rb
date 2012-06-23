module Fog
  module Rackspace
    class Identity
      class Real
        def list_user_roles(user_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users/#{user_id}/roles"
          )
        end
      end
    end
  end
end
