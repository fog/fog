module Fog
  module Compute
    class Brightbox
      class Real

        def get_user(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/users/#{identifier}", [200])
        end

      end
    end
  end
end