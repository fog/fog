module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_rnat
      end

      class Mock
        def get_rnat(uri)
        end
      end
    end
  end
end
