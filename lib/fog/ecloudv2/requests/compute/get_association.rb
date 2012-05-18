module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_association
      end

      class Mock
        def get_association(uri)
        end
      end
    end
  end
end
