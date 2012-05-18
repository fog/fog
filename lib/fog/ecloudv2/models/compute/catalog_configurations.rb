require 'fog/ecloudv2/models/compute/catalog_configuration'

module Fog
  module Compute
    class Ecloudv2
      class CatalogConfigurations < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::CatalogConfiguration

        def all
          data = connection.get_catalog_configurations(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_catalog_configuration(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
