require 'fog/collection'
require 'fog/bluebox/models/flavor'

module Fog
  module Bluebox
    class Compute

      class Flavors < Fog::Collection

        model Fog::Bluebox::Flavor

        def all
          data = connection.get_products.body
          load(data)
        end

        def get(product_id)
          response = connection.get_product(product_id)
          new(response.body)
        rescue Fog::Bluebox::NotFound
          nil
        end

      end

    end
  end
end
