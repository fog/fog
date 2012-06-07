module Fog
  module Compute
    class Ecloud

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
