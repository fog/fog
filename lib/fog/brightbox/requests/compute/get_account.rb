module Fog
  module Compute
    class Brightbox
      class Real

        def get_account(identifier = nil)
          if identifier.nil? || identifier.empty?
            request("get", "/1.0/account", [200])
          else
            request("get", "/1.0/accounts/#{identifier}", [200])
          end
        end

      end
    end
  end
end
