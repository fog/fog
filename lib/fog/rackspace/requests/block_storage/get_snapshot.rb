module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves snapshot detail
        # @param [String] snapshot_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'snapshot' [Hash]:
        #       * 'volume_id' [String]: -  volume_id of the snapshot
        #       * 'display_description' [String]: - snapshot display description
        #       * 'status' [String]: - snapshot status
        #       * 'os-extended-snapshot-attributes:project_id' [String]: -
        #       * 'id' [String]: - snapshot id
        #       * 'size' [Fixnum]: - size of the snapshot in GB
        #       * 'os-extended-snapshot-attributes:progress' [String]: -
        #       * 'display_name' [String]: - display name of snapshot
        #       * 'created_at' [String]: - creation time of snapshot
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshot__v1__tenant_id__snapshots.html
        def get_snapshot(snapshot_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def get_snapshot(snapshot_id)
          snapshot = self.data[:snapshots][snapshot_id]
          if snapshot.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            response(:body => {"snapshot" => snapshot})
          end
        end
      end
    end
  end
end
