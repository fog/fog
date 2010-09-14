module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_catalog_item
        end

        class Mock
          def get_catalog(catalog_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
