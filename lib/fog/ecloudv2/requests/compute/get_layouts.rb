module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_layouts
      end

      class Mock
        def get_layouts(uri)
        end
      end
    end
  end
end
