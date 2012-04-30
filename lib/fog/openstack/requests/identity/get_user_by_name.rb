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



      end
    end
  end
end
