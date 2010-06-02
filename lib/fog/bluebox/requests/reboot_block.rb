module Fog
  module Bluebox
    class Real

      # Reboot slice
      # ==== Parameters
      # * slice_id<~String> - Id of server to reboot
      # * type<~String> - Type of reboot, must be in ['HARD', 'SOFT']
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
      def reboot_block(block_id, type = 'SOFT')
        request(
          :expects  => 200,
          :method   => 'PUT',
          :path     => "api/blocks/#{block_id}/#{'soft_' if type == 'SOFT'}reboot.xml"
        )
      end

    end

    class Mock

      def reboot_block(block_id, type = 'SOFT')
        Fog::Mock.not_implemented
      end

    end
  end
end
