module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_environment
      end

      class Mock
        def get_environment(uri)
        end
      end
    end
  end
end
