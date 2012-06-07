module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_password_complexity_rules
      end

      class Mock
        def get_password_complexity_rules(uri)
        end
      end
    end
  end
end
