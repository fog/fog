module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves list of snapshots
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'snapshots' [Array]: -
        #       * 'volume_id' [String]: - volume_id of the snapshot
        #       * 'display_description' [String]: - display description of snapshot
        #       * 'status' [String]: - status of snapshot
        #       * 'id' [String]: - id of snapshot
        #       * 'size' [Fixnum]: - size of the snapshot in GB
        #       * 'display_name' [String]: - display name of snapshot
        #       * 'created_at' [String]: - creation time of snapshot
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshotsSimple__v1__tenant_id__snapshots.html
        def list_snapshots
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'snapshots'
          )
        end
      end

      class Mock
        def list_snapshots
          snapshots = self.data[:snapshots].values

          response(:body => {"snapshots" => snapshots})
        end
      end
    end
  end
end
