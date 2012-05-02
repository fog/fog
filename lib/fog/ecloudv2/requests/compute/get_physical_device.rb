module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_physical_device
      end

      class Mock
        def get_physical_device(uri)
        end
      end
    end
  end
end
