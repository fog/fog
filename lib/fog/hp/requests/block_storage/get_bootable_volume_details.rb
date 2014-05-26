module Fog
  module HP
    class BlockStorage
      class Real
        # Get details for existing block storage bootable volume
        #
        # ==== Parameters
        # * volume_id<~Integer> - Id of the volume to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volume<~Hash>:
        #       * 'id'<~Integer> - Id for the volume
        #       * 'displayName'<~String> - Name of the volume
        #       * 'displayDescription'<~String> - Description of the volume
        #       * 'size'<~Integer> - Size in GB for the volume
        #       * 'status'<~String> - Status of the volume i.e. "available"
        #       * 'volumeType'<~String> - Type of the volume
        #       * 'snapshotId'<~String> - Id of the volume snapshot
        #       * 'sourceImageRef'<~String> - Id of the volume snapshot
        #       * 'createdAt'<~String> - Timestamp in UTC when volume was created
        #       * 'availabilityZone'<~String> - Availability zone i.e. "nova"
        #       * attachments<~Array> Array of hashes of attachments
        #       * metadata<~Hash> Hash of metadata for the volume

        def get_bootable_volume_details(volume_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "hp-bootable-volumes/#{volume_id}"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def get_bootable_volume_details(volume_id)
          unless volume_id
            raise ArgumentError.new('volume_id is required')
          end
          response = Excon::Response.new
          if volume = self.data[:volumes][volume_id]
            response.status = 200
            response.body = { 'volume' => volume }
            response
          else
            raise Fog::HP::BlockStorage::NotFound
          end
        end
      end
    end
  end
end
