require 'fog/ecloud/models/compute/catalog_configuration'

module Fog
  module Compute
    class Ecloud
      class CatalogConfigurations < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::CatalogConfiguration

        def all
          data = service.get_catalog_configurations(href).body
          load(data)
        end

        def get(uri)
          if data = service.get_catalog_configuration(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
