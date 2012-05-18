module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_api_keys
      end

      class Mock
        def get_api_keys(uri)
        end
      end
    end
  end
end
