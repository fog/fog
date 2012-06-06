module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_api_key
      end

      class Mock
        def get_api_key(uri)
        end
      end
    end
  end
end
