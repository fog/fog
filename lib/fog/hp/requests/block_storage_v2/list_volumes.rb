module Fog
  module HP
    class BlockStorageV2
      class Real
        # List existing block storage volumes
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'display_name'<~String> - Name of the volume
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * volumes<~Hash>:
        #       * 'id'<~String> - UUId for the volume
        #       * 'display_name'<~String> - Name of the volume
        #       * 'display_description'<~String> - Description of the volume
        #       * 'size'<~Integer> - Size in GB for the volume
        #       * 'status'<~String> - Status of the volume i.e. "creating"
        #       * 'volume_type'<~String> - Type of the volume
        #       * 'snapshot_id'<~String> - UUId of the snapshot, the volume was created from.
        #       * 'source_volid'<~String> - UUId of a volume, the volume was created from.
        #       * 'created_at'<~String> - Timestamp in UTC when volume was created
        #       * 'availability_zone'<~String> - Availability zone i.e. "az1"
        #       * attachments<~Array>: Array of hashes of attachments
        #       * metadata<~Hash>: Hash of metadata for the volume
        def list_volumes(options = {})
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'volumes',
            :query    => options
          )
          response
        end
      end

      class Mock # :nodoc:all
        def list_volumes(options = {})
          response = Excon::Response.new
          volumes = []
          data = list_volumes_detail.body['volumes']
          for volume in data
            volumes << volume.reject { |key, _| ['volume_image_metadata'].include?(key) }
          end

          response.status = 200
          response.body = { 'volumes' => volumes }
          response
        end
      end
    end
  end
end
