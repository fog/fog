module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_group
      end

      class Mock
        def get_group(uri)
        end
      end
    end
  end
end
