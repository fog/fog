module Fog
  module HP
    class BlockStorageV2
      class Real
        # List details about existing block storage volume backups
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'name'<~String> - Name of the volume
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * backups<~Hash>:
        #       * 'id'<~String> - UUId for the volume backup
        #       * 'name'<~String> - Name of the volume backup
        #       * 'description'<~String> - Description of the volume backup
        #       * 'container'<~String> - The object storage container where the backup is stored. Defaults to 'volumebackups' if not specified at creating time.
        #       * 'status'<~String> - Status of the volume backup i.e. "available"
        #       * 'fail_reason'<~String> - Reason for failure of the volume backup
        #       * 'object_count'<~Integer> - Number of backups for a volume
        #       * 'size'<~Integer> - Size of the volume in the backup
        #       * 'volume_id'<~String> - UUId for the volume in the backup
        #       * 'created_at'<~String> - Timestamp in UTC when volume backup was created
        #       * 'availability_zone'<~String> - Availability zone of the backup volume. The backup is created in the same availability zone as the volume.
        #       * 'links'<~Array> - array of volume backup links
        def list_volume_backups_detail(options = {})
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'backups/detail',
            :query    => options
          )
          response
        end
      end

      class Mock # :nodoc:all
        def list_volume_backups_detail(options = {})
          response = Excon::Response.new
          backups = []
          backups = self.data[:volume_backups].values unless self.data[:volume_backups].nil?

          response.status = 200
          response.body = { 'backups' => backups }
          response
        end
      end
    end
  end
end
