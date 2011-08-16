module Fog
  module Compute
    class Brightbox
      class Real

        def get_account
          request("get", "/1.0/account", [200])
        end

      end
    end
  end
end