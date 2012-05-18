module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_associations
      end

      class Mock
        def get_associations(uri)
        end
      end
    end
  end
end
