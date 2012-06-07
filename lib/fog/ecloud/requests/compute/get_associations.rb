module Fog
  module Compute
    class Ecloud

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
