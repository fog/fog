module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves list of volumes
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'volumes' [Array]: -
        #       * 'volume_type' [String]: - volume type
        #       * 'display_description' [String]: - display desciption for volume
        #       * 'metadata' [Hash]: - metadata for volume
        #       * 'availability_zone' [String]: - region for volume
        #       * 'status' [String]: - status of volume
        #       * 'id' [String]: - id of volume
        #       * 'attachments' [Array]: - array of hashes containing attachment information
        #       * 'size' [Fixnum]: -  size of volume in GB (100 GB minimum)
        #       * 'snapshot_id' [String]: - optional snapshot from which to create a volume.
        #       * 'display_name' [String]: - display name of bolume
        #       * 'created_at' [String]: - volume creation time
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumesSimple__v1__tenant_id__volumes.html
        def list_volumes
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'volumes'
          )
        end
      end

      class Mock
        def list_volumes
          volumes = self.data[:volumes].values
          response(:body => {"volumes" => volumes})
        end
      end
    end
  end
end
