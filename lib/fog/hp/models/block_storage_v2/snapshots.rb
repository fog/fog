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

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          self.filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_snapshots_detail(non_aliased_filters).body['snapshots']
          else
            data = service.list_snapshots(non_aliased_filters).body['snapshots']
          end
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
