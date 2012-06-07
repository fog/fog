module Fog
  module Compute
    class Ecloud

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
