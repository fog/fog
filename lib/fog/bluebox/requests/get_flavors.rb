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
        response = Excon::Response.new
        response.status = 200
        response.body = { 'flavors' => [{:cost => 0.15, :description => "Test product", :id => "94fd37a7-2606-47f7-84d5-9000deda52ae", :name => "Bob's Haus o' Servers"}]}
        response
      end

    end
  end
end
