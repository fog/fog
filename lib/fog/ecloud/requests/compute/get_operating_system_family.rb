module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_operating_system
      end

      class Mock
        def get_operating_system(uri)
        end
      end
    end
  end
end
