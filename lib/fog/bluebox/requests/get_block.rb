module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_block'

      # Get details of a block.
      #
      # ==== Parameters
      # * block_id<~Integer> - Id of block to lookup
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      # TODO
      def get_block(block_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetBlock.new,
          :path     => "api/blocks/#{block_id}.xml"
        )
      end

    end

    class Mock

      def get_slice(id)
        Fog::Mock.not_implemented
      end

    end
  end
end
