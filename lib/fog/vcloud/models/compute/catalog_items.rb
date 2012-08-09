module Fog
  module Vcloud
    class Compute
      class CatalogItems < Fog::Vcloud::Collection

        undef_method :create

        model Fog::Vcloud::Compute::CatalogItem

        attribute :href, :aliases => :Href

        def all
          catalog_item_info = connection.get_catalog_item(self.href)
          items = connection.get_catalog_item(self.href).body[:CatalogItems]
          if items.size > 0
            data = items[:CatalogItem]
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

        def organization_uri
          @organization_uri ||= connection.default_organization_uri
        end

      end
    end
  end
end
