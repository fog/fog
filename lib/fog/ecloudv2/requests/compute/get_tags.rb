module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_tags
      end

      class Mock
        def get_tags(uri)
        end
      end
    end
  end
end
