module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_rnats
      end

      class Mock
        def get_rnats(uri)
        end
      end
    end
  end
end
