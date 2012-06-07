module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_roles
      end

      class Mock
        def get_roles(uri)
        end
      end
    end
  end
end
