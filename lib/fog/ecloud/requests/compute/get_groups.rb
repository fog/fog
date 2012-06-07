module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_groups
      end

      class Mock
        def get_groups(uri)
        end
      end
    end
  end
end
