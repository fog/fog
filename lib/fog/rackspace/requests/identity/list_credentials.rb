module Fog
  module Rackspace
    class Identity
      class Real
        def list_credentials(user_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users/#{user_id}/OS-KSADM/credentials"
          )
        end
      end
    end
  end
end
