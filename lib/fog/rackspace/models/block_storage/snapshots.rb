require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/snapshot'

module Fog
  module Rackspace
    class BlockStorage
      class Snapshots < Fog::Collection
        model Fog::Rackspace::BlockStorage::Snapshot

        # Returns list of snapshots
        # @return [Fog::Rackspace::BlockStorage::Snapshots] Retrieves a snapshots
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshotsSimple__v1__tenant_id__snapshots.html
        def all
          data = service.list_snapshots.body['snapshots']
          load(data)
        end

        # Retrieves snapshot
        # @param [String] snapshot_id for snapshot to be returned
        # @return [Fog::Rackspace::BlockStorage::Volume]
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshot__v1__tenant_id__snapshots.html
        def get(snapshot_id)
          data = service.get_snapshot(snapshot_id).body['snapshot']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
