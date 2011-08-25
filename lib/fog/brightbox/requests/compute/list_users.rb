module Fog
  module Compute
    class Brightbox
      class Real

        def list_users
          request("get", "/1.0/users", [200])
        end

      end
    end
  end
end