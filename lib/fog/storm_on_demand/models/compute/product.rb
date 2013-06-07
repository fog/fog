require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Product < Fog::Model
        identity :code
        attribute :alias
        attribute :capabilities
        attribute :categories
        attribute :cycle
        attribute :default_price
        attribute :description
        attribute :features
        attribute :options
        attribute :parent_product
        attribute :prices
        attribute :related_product
        attribute :series

        def initialize(attributes={})
          super
        end

        def price(options)
          requires :identity
          service.get_product_price({:code => identity}.merge!(options)).body
        end

        def starting_price
          requires :identity
          service.get_product_starting_price(:code => identity).body['items']
        end

      end

    end
  end
end
