module Fog
  module Rackspace
    class Identity
      class Real
        def get_user_by_id(user_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users/#{user_id}"
          )
        end
      end
    end
  end
end
