require 'fog/ecloud/models/compute/catalog_item'

module Fog
  module Compute
    class Ecloud
      class Catalog < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::CatalogItem

        def all
          data = service.get_catalog(href).body#[:Locations][:Location][:Catalog][:CatalogEntry]
          if data[:Locations][:Location].is_a?(Hash)
            data = [] if data[:Locations][:Location][:Catalog].is_a?(String) && data[:Locations][:Location][:Catalog].empty?
            load(data)
          elsif data[:Locations][:Location].is_a?(Array)
            r_data = []
            data[:Locations][:Location].each do |d|
              unless d[:Catalog].is_a?(String) && d[:Catalog].empty?
                d[:Catalog][:CatalogEntry].each do |c|
                  r_data << c
                end
              end
            end
            load(r_data)
          end
        end

        def get(uri)
          if data = service.get_catalog_item(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
