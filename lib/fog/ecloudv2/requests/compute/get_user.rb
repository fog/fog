module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_user
      end

      class Mock
        def get_user(uri)
        end
      end
    end
  end
end
