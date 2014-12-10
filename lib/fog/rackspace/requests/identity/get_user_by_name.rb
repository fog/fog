module Fog
  module Rackspace
    class Identity
      class Real
        def get_user_by_name(username)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users?name=#{username}"
          )
        end
      end
    end
  end
end
