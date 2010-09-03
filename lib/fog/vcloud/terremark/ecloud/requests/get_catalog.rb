module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_catalog
        end

        module Mock
          def get_catalog(catalog_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
