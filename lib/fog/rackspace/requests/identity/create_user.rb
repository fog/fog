module Fog
  module Rackspace
    class Identity
      class Real
        def create_user(username, email, enabled, options = {})
          data = {
            'user' => {
              'username' => username,
              'email' => email,
              'enabled' => enabled
            }
          }
          data['user']['OS-KSADM:password'] = options[:password] unless options[:password].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [201],
            :method => 'POST',
            :path => 'users'
          )
        end
      end
    end
  end
end
