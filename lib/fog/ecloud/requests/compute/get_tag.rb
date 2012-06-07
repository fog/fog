module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_tag
      end

      class Mock
        def get_tag(uri)
        end
      end
    end
  end
end
