module Fog
  module Compute
    class Ecloudv2

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
