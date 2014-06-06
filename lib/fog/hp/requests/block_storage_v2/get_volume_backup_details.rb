module Fog
  module HP
    class BlockStorageV2
      class Real
        # Get details for existing block storage volume backup
        #
        # ==== Parameters
        # * 'backup_id'<~String> - UUId of the volume backup to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * backup<~Hash>:
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
        def get_volume_backup_details(backup_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "backups/#{backup_id}"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def get_volume_backup_details(backup_id)
          response = Excon::Response.new
          if backup = self.data[:volume_backups][backup_id]
            response.status = 200
            response.body = { 'backup' => backup }
            response
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
        end
      end
    end
  end
end
