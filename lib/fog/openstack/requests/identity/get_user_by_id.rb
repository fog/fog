module Fog
  module Identity
    class Openstack
      class Real

        def get_user_by_id(user_id)
          
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "users/#{user_id}"
          )
        end

      end

      class Mock



      end
    end
  end
end
