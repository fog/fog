module Fog
  module Parsers
    module Terremark
      module Shared

        class GetCatalog < TerremarkParser

          def reset
            @response = { 'CatalogItems' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'CatalogItem'
              catalog_item = extract_attributes(attributes)
              catalog_item["id"] = catalog_item["href"].split('/').last
              @response['CatalogItems'] << catalog_item

            when 'Catalog'
              catalog = extract_attributes(attributes)
              @response['name'] = catalog['name']
            end
          end

          def end_element(name)
            if name == 'Description'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
