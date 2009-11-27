unless Fog.mocking?

  module Fog
    class Slicehost

      # Get list of slices
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'addresses'<~Array> - Ip addresses for the slice
      #     * 'backup_id'<~Integer> - Id of backup slice was booted from
      #     * 'bw_in'<~Integer> - Incoming bandwidth total for current billing cycle, in Gigabytes
      #     * 'bw_out'<~Integer> - Outgoing bandwidth total for current billing cycle, in Gigabytes
      #     * 'flavor_id'<~Integer> - Id of flavor slice was booted from
      #     * 'id'<~Integer> - Id of the slice
      #     * 'image_id'<~Integer> - Id of image slice was booted from
      #     * 'name'<~String> - Name of the slice
      #     * 'progress'<~Integer> - Progress of current action, in percentage
      #     * 'status'<~String> - Current status of the slice
      def get_slices
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Slicehost::GetSlices.new,
          :path     => 'slices.xml'
        )
      end

    end
  end

else

  module Fog
    class Slicehost

      def get_slices
      end

    end
  end

end
