module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_monitors
      end

      class Mock
        def get_monitors(uri)
        end
      end
    end
  end
end
