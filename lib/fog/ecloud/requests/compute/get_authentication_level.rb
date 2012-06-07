module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_authentication_level
      end

      class Mock
        def get_authentication_level(uri)
        end
      end
    end
  end
end
