unless Fog.mocking?

  module Fog
    class Slicehost

      # Get list of slices
      # ==== Parameters
      # * flavor_id<~Integer> - Id of flavor to create slice with
      # * image_id<~Integer> - Id of image to create slice with
      # * name<~String> - Name of slice
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'addresses'<~Array> - Ip addresses for the slice
      #     * 'backup-id'<~Integer> - Id of backup slice was booted from
      #     * 'bw-in'<~Integer> - Incoming bandwidth total for current billing cycle, in Gigabytes
      #     * 'bw-out'<~Integer> - Outgoing bandwidth total for current billing cycle, in Gigabytes
      #     * 'flavor-id'<~Integer> - Id of flavor slice was booted from
      #     * 'id'<~Integer> - Id of the slice
      #     * 'image-id'<~Integer> - Id of image slice was booted from
      #     * 'name'<~String> - Name of the slice
      #     * 'progress'<~Integer> - Progress of current action, in percentage
      #     * 'root-password'<~String> - Root password of slice
      #     * 'status'<~String> - Current status of the slice
      def delete_slice(slice_id)
        request(
          :expects  => 200,
          :method   => 'DELETE',
          :path     => "slices/#{slice_id}.xml"
        )
      end

    end
  end

else

  module Fog
    class Slicehost

      def delete_slice(slice_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end

end
