module Fog
  module HP
    class BlockStorage
      class Real
        # Get details for existing block storage snapshot
        #
        # ==== Parameters
        # * snapshot_id<~Integer> - Id of the snapshot to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * snapshot<~Hash>:
        #       * 'id'<~Integer>: - Id for the snapshot
        #       * 'displayName'<~String>: - Name of the snapshot
        #       * 'displayDescription'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "available"
        #       * 'volumeId'<~Integer>: - Id of the volume from which the snapshot was created
        #       * 'createdAt'<~String>: - Timestamp in UTC when volume was created

        def get_snapshot_details(snapshot_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "os-snapshots/#{snapshot_id}"
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
            raise Fog::HP::BlockStorage::NotFound
          end
        end
      end
    end
  end
end
