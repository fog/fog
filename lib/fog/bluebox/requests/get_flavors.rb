module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_flavors'

      # Get list of products
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'id'<~String> - UUID of the product
      #     * 'description'<~String> - Description of the product
      #     * 'cost'<~Decimal> - Hourly cost of the product
      def get_flavors
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetFlavors.new,
          :path     => 'api/block_products.xml'
        )
      end

    end

    class Mock

      def get_flavors
        Fog::Mock.not_implemented
      end

    end
  end
end
