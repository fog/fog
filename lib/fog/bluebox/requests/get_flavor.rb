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
      # TODO
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
        Fog::Mock.not_implemented
      end

    end
  end
end
