module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_monitor
      end

      class Mock
        def get_monitor(uri)
        end
      end
    end
  end
end
