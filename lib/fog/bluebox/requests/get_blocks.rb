module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_blocks'

      # Get list of blocks
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'ips'<~Array> - Ip addresses for the block
      #     * 'id'<~String> - Id of the block
      #     * 'storage'<~Integer> - Disk space quota for the block
      #     * 'memory'<~Integer> - RAM quota for the block
      #     * 'cpu'<~Float> - The fractional CPU quota for this block
      #     * 'hostname'<~String> - The hostname for the block
      def get_blocks
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetBlocks.new,
          :path     => 'api/blocks.xml'
        )
      end

    end

    class Mock

      def get_slices
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
