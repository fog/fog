module Fog
  module Rackspace
    class Identity
      class Real
        def list_users()
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'users'
          )
        end
      end
    end
  end
end
