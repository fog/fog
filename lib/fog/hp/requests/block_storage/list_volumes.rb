module Fog
  module HP
    class BlockStorage
      class Real

        # List existing block storage volumes
        #
        # ==== Parameters
        # None
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * volumes<~Hash>:
        #       * 'id'<~Integer>: - Id for the volume
        #       * 'displayName'<~String>: - Name of the volume
        #       * 'displayDescription'<~String>: - Description of the volume
        #       * 'size'<~Integer>: - Size in GB for the volume
        #       * 'status'<~String>: - Status of the volume i.e. "available"
        #       * 'volumeType'<~String>: - Type of the volume
        #       * 'snapshotId'<~String>: - Id of the volume snapshot
        #       * 'createdAt'<~String>: - Timestamp in UTC when volume was created
        #       * 'availabilityZone'<~String>: - Availability zone i.e. "nova"
        #       * attachments<~Array>: Array of hashes of attachments
        #       * metadata<~Hash>: Hash of metadata for the volume
        def list_volumes
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'os-volumes'
          )
          response
        end

      end

      class Mock # :nodoc:all

        def list_volumes
          response = Excon::Response.new
          volumes = []
          volumes = self.data[:volumes].values unless self.data[:volumes].nil?

          response.status = 200
          response.body = { 'volumes' => volumes }
          response
        end
      end

    end
  end
end