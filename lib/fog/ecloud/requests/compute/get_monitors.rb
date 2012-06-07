module Fog
  module Compute
    class Ecloud

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
