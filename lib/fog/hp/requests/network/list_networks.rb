module Fog
  module HP
    class Network

      class Real

        # List existing networks
        #
        # ==== Parameters
        # * options<~Hash>:
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
        def list_networks(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'networks',
            :query   => options
          )
        end
      end

      class Mock
        def list_networks(options = {})
          response = Excon::Response.new

          networks = self.data[:networks].values
          response.status = 200
          response.body = { 'networks' => networks }
          response
        end
      end

    end
  end
end