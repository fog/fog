module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_authentication_levels
      end

      class Mock
        def get_authentication_levels(uri)
        end
      end
    end
  end
end
