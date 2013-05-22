require 'fog/core/collection'
require 'fog/hp/models/block_storage_v2/volume'

module Fog
  module HP
    class BlockStorageV2

      class Volumes < Fog::Collection

        attribute :filters

        model Fog::HP::BlockStorageV2::Volume

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.list_volumes(filters).body['volumes']
          load(data)
        end

        def get(volume_id)
          volume = service.get_volume_details(volume_id).body['volume']
          new(volume)
        rescue Fog::HP::BlockStorageV2::NotFound
          nil
        end

      end

    end
  end
end
