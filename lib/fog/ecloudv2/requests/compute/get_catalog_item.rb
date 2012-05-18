module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_catalog_item
      end

      class Mock
        def get_catalog_item(uri)
        end
      end
    end
  end
end
