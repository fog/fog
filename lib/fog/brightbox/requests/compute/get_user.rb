module Fog
  module Compute
    class Brightbox
      class Real

        def get_user(identifier = nil)
          if identifier.nil? || identifier.empty?
            request("get", "/1.0/user", [200])
          else
            request("get", "/1.0/users/#{identifier}", [200])
          end
        end

      end
    end
  end
end
