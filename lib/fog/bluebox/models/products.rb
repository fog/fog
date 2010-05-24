require 'fog/collection'
require 'fog/bluebox/models/product'

module Fog
  module Bluebox

    class Mock
      def products
        Fog::Bluebox::Products.new(:connection => self)
      end
    end

    class Real
      def products
        Fog::Bluebox::Products.new(:connection => self)
      end
    end

    class Products < Fog::Collection

      model Fog::Bluebox::Product

      def all
        data = connection.get_products.body['products']
        load(data)
      end

      def get(product_id)
        connection.get_product(product_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
