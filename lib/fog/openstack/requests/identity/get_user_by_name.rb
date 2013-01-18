module Fog
  module Identity
    class OpenStack
      class Real

        def get_user_by_name(name)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "users?name=#{name}"
          )
        end

      end

      class Mock

        def get_user_by_name(name)
          response = Excon::Response.new
          response.status = 200

          response.body = {
            'users' => self.data[:users].values
          }
          response
        end

      end
    end
  end
end
