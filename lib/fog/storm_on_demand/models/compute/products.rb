require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/product'

module Fog
  module Compute
    class StormOnDemand
      class Products < Fog::Collection
        model Fog::Compute::StormOnDemand::Product

        def get(product_code)
          prod = service.get_product(:code => product_code).body
          new(prod)
        end

        def get_product_code(options)
          service.get_product_code(options).body
        end

        def all(options={})
          service.list_products(options).body['items']
        end
      end
    end
  end
end
