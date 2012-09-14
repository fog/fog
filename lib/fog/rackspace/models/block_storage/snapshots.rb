require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/snapshot'

module Fog
  module Rackspace
    class BlockStorage
      class Snapshots < Fog::Collection

        model Fog::Rackspace::BlockStorage::Snapshot

        def all
          data = connection.list_snapshots.body['snapshots']
          load(data)
        end

        def get(snapshot_id)
          data = connection.get_snapshot(snapshot_id).body['snapshot']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
