module Fog
  module HP
    class BlockStorageV2
      class Real
        # List existing block storage snapshots
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'display_name'<~String> - Name of the snapshot
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * snapshots<~Hash>:
        #       * 'id'<~String>: - UUId for the snapshot
        #       * 'display_name'<~String>: - Name of the snapshot
        #       * 'display_description'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. 'available'
        #       * 'volume_id'<~String>: - UUId of the volume from which the snapshot was created
        #       * 'created_at'<~String>: - Timestamp in UTC when volume was created
        #       * metadata<~Hash>: Hash of metadata for the snapshot
        def list_snapshots(options={})
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'snapshots',
            :query    => options
          )
          response
        end
      end

      class Mock # :nodoc:all
        def list_snapshots(options={})
          response = Excon::Response.new
          snapshots = []
          data = list_snapshots_detail.body['snapshots']
          for snapshot in data
            snapshots << snapshot.reject { |key, _| ['volume_image_metadata'].include?(key) }
          end

          response.status = 200
          response.body = { 'snapshots' => snapshots }
          response
        end
      end
    end
  end
end
