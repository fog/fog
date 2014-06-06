module Fog
  module HP
    class BlockStorageV2
      class Real
        # Get details for existing block storage snapshot
        #
        # ==== Parameters
        # * 'snapshot_id'<~String> - UUId of the snapshot to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * snapshot<~Hash>:
        #       * 'id'<~String>: - UUId for the snapshot
        #       * 'display_name'<~String>: - Name of the snapshot
        #       * 'display_description'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "available"
        #       * 'volume_id'<~String>: - UUId of the volume from which the snapshot was created
        #       * 'created_at'<~String>: - Timestamp in UTC when volume was created
        #       * metadata<~Hash>: Hash of metadata for the snapshot
        def get_snapshot_details(snapshot_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "snapshots/#{snapshot_id}"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def get_snapshot_details(snapshot_id)
          unless snapshot_id
            raise ArgumentError.new('snapshot_id is required')
          end
          response = Excon::Response.new
          if snapshot = self.data[:snapshots][snapshot_id]
            response.status = 200
            response.body = { 'snapshot' => snapshot }
            response
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
        end
      end
    end
  end
end
