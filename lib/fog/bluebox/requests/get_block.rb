module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_block'

      # Get details of a block.  We do this by looking at the
      #
      # ==== Parameters
      # * slice_id<~Integer> - Id of slice to lookup
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'addresses'<~Array> - Ip addresses for the slice
      #     * 'backup-id'<~Integer> - Id of backup slice was booted from
      #     * 'bw-in'<~Float> - Incoming bandwidth total for current billing cycle, in Gigabytes
      #     * 'bw-out'<~Float> - Outgoing bandwidth total for current billing cycle, in Gigabytes
      #     * 'flavor_id'<~Integer> - Id of flavor slice was booted from
      #     * 'id'<~Integer> - Id of the slice
      #     * 'image-id'<~Integer> - Id of image slice was booted from
      #     * 'name'<~String> - Name of the slice
      #     * 'progress'<~Integer> - Progress of current action, in percentage
      #     * 'status'<~String> - Current status of the slice
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
