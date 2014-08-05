require 'fog/core/collection'
require 'fog/hp/models/block_storage/volume'

module Fog
  module HP
    class BlockStorage
      class Volumes < Fog::Collection
        model Fog::HP::BlockStorage::Volume

        def all
          data = service.list_volumes.body['volumes']
          load(data)
        end

        def get(volume_id)
          volume = service.get_volume_details(volume_id).body['volume']
          new(volume)
        rescue Fog::HP::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
