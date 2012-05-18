module Fog
  module Compute
    class Ecloudv2

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
