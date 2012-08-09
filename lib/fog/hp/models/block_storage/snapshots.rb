require 'fog/core/collection'
require 'fog/hp/models/block_storage/snapshot'

module Fog
  module BlockStorage
    class HP

      class Snapshots < Fog::Collection

        model Fog::BlockStorage::HP::Snapshot

        def all
          data = connection.list_snapshots.body['snapshots']
          load(data)
        end

        def get(snapshot_id)
          if snapshot = connection.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::BlockStorage::HP::NotFound
          nil
        end

      end

    end
  end
end
