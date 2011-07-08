module Fog
  module Vcloud
    class Compute
      class CatalogItems < Fog::Vcloud::Collection

        undef_method :create

        model Fog::Vcloud::Compute::CatalogItem

        attribute :href, :aliases => :Href

        def all
          data = connection.get_catalog(href).body[:CatalogItems][:CatalogItem]
          load(data)
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
