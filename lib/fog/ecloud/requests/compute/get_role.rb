module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_role
      end

      class Mock
        def get_role(uri)
        end
      end
    end
  end
end
