module Fog
  module Ecloud
    class Compute
      class Catalog < Fog::Ecloud::Collection

        model Fog::Ecloud::Compute::CatalogItem

        attribute :href, :aliases => :Href

        def all
          check_href!
          if data = connection.get_catalog(href).body[:CatalogItems][:CatalogItem]
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_catalog_item(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
