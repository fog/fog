module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_layout
      end

      class Mock
        def get_layout(uri)
        end
      end
    end
  end
end
