module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_products'

      # Get list of products
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'id'<~String> - UUID of the product
      #     * 'description'<~String> - Description of the product
      #     * 'cost'<~Decimal> - Hourly cost of the product
      def get_products
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetProducts.new,
          :path     => 'api/products.xml'
        )
      end

    end

    class Mock

      def get_images
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
