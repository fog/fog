module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_flavor'

      # Get details of a flavor
      #
      # ==== Parameters
      # * flavor_id<~Integer> - Id of flavor to lookup
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'id'<~Integer> - Id of the flavor
      #     * 'name'<~String> - Name of the flavor
      #     * 'price'<~Integer> - Price in cents
      #     * 'ram'<~Integer> - Amount of ram for the flavor
      def get_flavor(flavor_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetFlavor.new,
          :path     => "api/block_products/#{flavor_id}.xml"
        )
      end

    end

    class Mock

      def get_flavor(flavor_id)
        if flavor_id == "0"
          nil
        else
          Flavor.new(:cost => 0.15, :description => "Test product", :id => "94fd37a7-2606-47f7-84d5-9000deda52ae", :name => "Bob's Haus o' Servers")
        end
      end

    end
  end
end
