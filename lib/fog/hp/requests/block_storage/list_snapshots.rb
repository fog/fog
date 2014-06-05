module Fog
  module HP
    class BlockStorage
      class Real
        # List existing block storage snapshots
        #
        # ==== Parameters
        # None
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * snapshots<~Hash>:
        #       * 'id'<~Integer>: - Id for the snapshot
        #       * 'displayName'<~String>: - Name of the snapshot
        #       * 'displayDescription'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "available"
        #       * 'volumeId'<~Integer>: - Id of the volume from which the snapshot was created
        #       * 'createdAt'<~String>: - Timestamp in UTC when volume was created
        def list_snapshots
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'os-snapshots'
          )
          response
        end
      end

      class Mock # :nodoc:all
        def list_snapshots
          response = Excon::Response.new
          snapshots = []
          snapshots = self.data[:snapshots].values unless self.data[:snapshots].nil?

          response.status = 200
          response.body = { 'snapshots' => snapshots }
          response
        end
      end
    end
  end
end
