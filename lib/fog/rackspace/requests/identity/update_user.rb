module Fog
  module Rackspace
    class Identity
      class Real
        def update_user(user_id, username, email, enabled, options = {})
          data = {
            'user' => {
              'username' => username,
              'email' => email,
              'enabled' => enabled
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200, 203],
            :method => 'POST',
            :path => "users/#{user_id}"
          )
        end
      end
    end
  end
end
