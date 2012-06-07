module Fog
  module Compute
    class Ecloud

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
