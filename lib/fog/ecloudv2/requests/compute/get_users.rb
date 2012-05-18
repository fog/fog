module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_users
      end

      class Mock
        def get_users(uri)
        end
      end
    end
  end
end
