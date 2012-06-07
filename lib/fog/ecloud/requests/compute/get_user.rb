module Fog
  module Compute
    class Ecloud

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
