module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_catalog
      end

      class Mock
        def get_catalog(uri)
        end
      end
    end
  end
end
