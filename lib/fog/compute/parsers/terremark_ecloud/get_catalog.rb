module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetCatalog < Fog::Parsers::Base

          def reset
            @response = { 'catalogItems' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'Catalog'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
            when 'CatalogItems'
              @in_catalog_items = true
            when 'CatalogItem'
              if @in_catalog_items
                @response['catalogItems'].push({
                                                 'name' => attr_value('name', attrs),
                                                 'uri'  => attr_value('href', attrs)
                                               })
              end
            end

            super
          end

          def end_element(name)
            case name
            when 'CatalogItems'
              @in_catalog_items = false
            end
          end
        end
      end
    end
  end
end
