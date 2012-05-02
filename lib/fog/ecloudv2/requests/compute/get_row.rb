module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_row
      end

      class Mock
        def get_row(uri)
        end
      end
    end
  end
end
