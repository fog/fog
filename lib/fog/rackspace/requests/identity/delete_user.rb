module Fog
  module Rackspace
    class Identity
      class Real
        def delete_user(user_id)
          request(
            :expects => [204],
            :method => 'DELETE',
            :path => "users/#{user_id}"
          )
        end
      end
    end
  end
end
