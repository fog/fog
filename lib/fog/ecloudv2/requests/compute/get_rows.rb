module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_rows
      end

      class Mock
        def get_rows(uri)
        end
      end
    end
  end
end
