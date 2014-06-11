module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Delete snapshot
        #
        # @param [String] snapshot_id Id of snapshot to delete
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createSnapshot__v1__tenant_id__snapshots.html
        def delete_snapshot(snapshot_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def delete_snapshot(snapshot_id)
          self.data[:snapshots].delete(snapshot_id)
          response(:status => 202)
        end
      end
    end
  end
end
