module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_catalog_configurations
      end

      class Mock
        def get_catalog_configurations(uri)
        end
      end
    end
  end
end
