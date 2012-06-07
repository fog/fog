module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_password_complexity_rule
      end

      class Mock
        def get_password_complexity_rule(uri)
        end
      end
    end
  end
end
