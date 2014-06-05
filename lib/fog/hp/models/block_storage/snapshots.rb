require 'fog/core/collection'
require 'fog/hp/models/block_storage/snapshot'

module Fog
  module HP
    class BlockStorage
      class Snapshots < Fog::Collection
        model Fog::HP::BlockStorage::Snapshot

        def all
          data = service.list_snapshots.body['snapshots']
          load(data)
        end

        def get(snapshot_id)
          if snapshot = service.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::HP::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
