require 'fog/collection'
require 'fog/bluebox/models/flavor'

module Fog
  module Bluebox

    class Mock
      def flavors
        Fog::Bluebox::Flavors.new(:connection => self)
      end
    end

    class Real
      def flavors
        Fog::Bluebox::Flavors.new(:connection => self)
      end
    end

    class Flavors < Fog::Collection

      model Fog::Bluebox::Flavor

      def all
        data = connection.get_product.body['products']
        load(data)
      end

      def get(product_id)
        response = connection.get_product(product_id)
        new(response.body)
      rescue Excon::Errors::Forbidden, Excon::Errors::NotFound
        nil
      end

    end

  end
end
