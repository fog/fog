module Fog
  module Compute
    class Brightbox
      class Real

        def list_accounts
          request("get", "/1.0/accounts", [200])
        end

      end
    end
  end
end