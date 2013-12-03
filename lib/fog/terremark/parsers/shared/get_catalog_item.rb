module Fog
  module Parsers
    module Terremark
      module Shared

        class GetCatalogItem < TerremarkParser

          def reset
            @response = { 'Entity' => {}, 'Properties' => {} }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Entity'
              @response['Entity'] = extract_attributes(attributes)
            when 'CatalogItem'
              catalog_item = extract_attributes(attributes)
              @response['name'] = catalog_item['name']
            when 'Property'
              @property_key = attributes.value
            end
          end

          def end_element(name)
            if name == 'Property'
              @response['Properties'][@property_key] = value
            end
          end

        end

      end
    end
  end
end
