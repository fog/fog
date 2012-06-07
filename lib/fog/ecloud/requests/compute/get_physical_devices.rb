module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_physical_devices
      end

      class Mock
        def get_physical_devices(uri)
        end
      end
    end
  end
end
