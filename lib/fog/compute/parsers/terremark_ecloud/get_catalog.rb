module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetCatalog < Fog::Parsers::Base

          def reset
            @response = { 'CatalogItems' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'Catalog'
              for attribute in %w{href name}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
            when 'CatalogItem'
              catalog_item = {}
              for attribute in %w{href name rel type}
                if value = attr_value(attribute, attrs)
                  catalog_item[attribute] = value
                end
              end
              @response['CatalogItems'] << catalog_item
            end

            super
          end
        end
      end
    end
  end
end
