require 'fog/core/collection'
require 'fog/bluebox/models/compute/flavor'

module Fog
  module Compute
    class Bluebox
      class Flavors < Fog::Collection
        model Fog::Compute::Bluebox::Flavor

        def all
          data = service.get_products.body
          load(data)
        end

        def get(product_id)
          response = service.get_product(product_id)
          new(response.body)
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end
      end
    end
  end
end
