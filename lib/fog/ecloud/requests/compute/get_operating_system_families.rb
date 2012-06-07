module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_operating_system_families
      end

      class Mock
        def get_operating_system_families(uri)
        end
      end
    end
  end
end
