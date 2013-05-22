require 'fog/core/collection'
require 'fog/hp/models/block_storage_v2/snapshot'

module Fog
  module HP
    class BlockStorageV2

      class Snapshots < Fog::Collection

        attribute :filters

        model Fog::HP::BlockStorageV2::Snapshot

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.list_snapshots(filters).body['snapshots']
          load(data)
        end

        def get(snapshot_id)
          if snapshot = service.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::HP::BlockStorageV2::NotFound
          nil
        end

      end

    end
  end
end
